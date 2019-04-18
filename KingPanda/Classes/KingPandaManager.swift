//
//  NetworkManager.swift
//  CityPartner
//
//  Created by PEACEMINUSONE on 2018/4/28.
//  Copyright © 2018年 com.pinguo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

open class KingPandaManager {
    ///singleton pattern
    static let shared = KingPandaManager()
    
    open var configure = NetworkConfig.shared
    
    open var recordRequests: [Int: BaseRequest] = [:]
    
    fileprivate let lock = NSLock()
    
    fileprivate let defaultTimeout = 60.0
    
    fileprivate let queue = DispatchQueue(label: "com.kingpanda.queue", qos: .userInteractive, attributes: .concurrent)
}

// MARK: - method
extension KingPandaManager {

    /// send request
    func addRequest(_ request: BaseRequest) {
       
        ///manually send network requests
        SessionManager.default.startRequestsImmediately = false
        
        ///user custom url
        let customUrl: String? = request.configInfo?.customRequestUrl
        if customUrl != nil {
            let requestData: DataRequest = Alamofire.request(customUrl!)
            requestData.responseJSON { [weak self] (response) in
                self?.handleResponseResult(requestData.task!, response)
            }
            request.requestTask = requestData.task
        } else {
            
            guard request.configInfo?.baseUrl != nil else { return }
            guard request.configInfo?.pathUrl != nil else { return }
            
            request.requestTask = sessionTaskForRequest(request)
        }
        
        assert(request.requestTask != nil, "requestTask should not be nil")
        addRequestToRecord(request)
        request.requestTask?.resume()
    }
    
    ///cancel current request
    func cancelRequest(_ request: BaseRequest) {
        request.requestTask?.cancel()
        removeRequestFromRecord(request)
    }
    
    //cancel all reuqest
    func cancelAllRequests() {
        lock.lock()
        let allKeys = self.recordRequests.keys
        lock.unlock()
        
        for key in allKeys {
            lock.lock()
            let request: BaseRequest = self.recordRequests[key]!
            lock.unlock()
            request.stop()
        }
    }
    
    ///save request to dictionary
    func addRequestToRecord(_ request: BaseRequest) {
        lock.lock(); defer { lock.unlock() }
        recordRequests[(request.requestTask?.taskIdentifier)!] = request
    }
    
    ///delete request from dictionary
    func removeRequestFromRecord(_ request: BaseRequest) {
        lock.lock(); defer { lock.unlock() }
        recordRequests.removeValue(forKey: (request.requestTask?.taskIdentifier)!)
    }
}

// MARK: - request method
extension KingPandaManager {
    
    func sessionTaskForRequest(_ request: BaseRequest) -> URLSessionTask{
        
        let baseUrl = request.configInfo?.baseUrl
        let params: [String: Any]? = request.configInfo?.requestParams
        let pathUrl = request.configInfo?.pathUrl
        let url = URL.init(string: pathUrl!, relativeTo: URL(string: baseUrl!))
        
        var method = request.configInfo?.method
        if method == nil {
            method = HttpMethod.GET
        }
        
        var header = request.configInfo?.httpHeader
        if header == nil {
            header = SessionManager.defaultHTTPHeaders
        }
        
        /// set timeout, default 60 sec
        if let timeout = request.requestTimeout {
            SessionManager.default.session.configuration.timeoutIntervalForRequest = timeout
        } else {
            SessionManager.default.session.configuration.timeoutIntervalForRequest = defaultTimeout
        }
        
        var paramsEncoding: ParameterEncoding?
        let encoding = request.configInfo?.encoding
        if encoding == .JSON {
            paramsEncoding = JSONEncoding.default
        } else {
            paramsEncoding = URLEncoding.default
        }
        
        switch method! {
        case .POST:
            return dataRequestTask(url!, .post, params, paramsEncoding!, header!)
        case .GET:
            return dataRequestTask(url!, .get, params, paramsEncoding!, header!)
        case .PUT:
            return dataRequestTask(url!, .put, params, paramsEncoding!, header!)
        case .DELETE:
            return dataRequestTask(url!, .delete, params, paramsEncoding!, header!)
        }
    }
    
    func dataRequestTask(_ url: URL, _ method: HTTPMethod, _ params: [String: Any]?, _ encoding: ParameterEncoding, _ header: [String: String]) -> URLSessionTask {
        let requestData = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: header)
        requestData.responseJSON { (response) in
            self.handleResponseResult(requestData.task!, response)
        }
        return requestData.task!
    }
    
    func uploadTask() -> URLSessionTask {
        return URLSessionTask()
    }
    
    func downloadTask() -> URLSessionTask {
        return URLSessionTask()
    }
}

// MARK: - response method
extension KingPandaManager {
    
    func handleResponseResult(_ task: URLSessionTask, _ response: DataResponse<Any>) {
        lock.lock()
        let request: BaseRequest = self.recordRequests[task.taskIdentifier]!
        lock.unlock()
        
        request.responseData = response.data
        request.responseObject = response.result.value
        request.error = response.result.error
        
        switch response.result {
        case .success(_):
            
            let type: ResponseType = (request.configInfo?.responseType)!
            switch type {
            case .dictionary:
                request.modelData = response.result.value as! [String: Any]
                break
            case .string:
                request.modelData = response.result.value
                break
            case .model:
                break
            case .array:
                break
            }
            
            self.handleSuccessResult(request)
            break
            
        case .failure(_):
            self.handleFailureResult(request)
            break
        }
    }
    
    func handleSuccessResult(_ request: BaseRequest) {
        
        if request.delegate != nil {
            request.delegate?.requestSuccess(request)
        }
        
        if (request.requestSuccessed != nil) {
            request.requestSuccessed!(request)
        }
    }
    
    func handleFailureResult(_ request: BaseRequest) {
        
        if request.delegate != nil {
            request.delegate?.requestFailure(request)
        }
        
        if (request.requestFailed != nil) {
            request.requestFailed!(request)
        }
    }
}

//MARK: - response data is model type
extension KingPandaManager {
    /// send request
    func addRequest<T: BaseMappable>(_ request: BaseRequest, _ model: T) {
        
        ///manually send network requests
        SessionManager.default.startRequestsImmediately = false
        
        ///user custom url
        let customUrl: String? = request.configInfo?.customRequestUrl
        if customUrl != nil {
            let requestData: DataRequest = Alamofire.request(customUrl!)
            requestData.responseString { [weak self] (response) in
                self?.handleResponseModelResult(requestData.task!, response, model)
            }
            request.requestTask = requestData.task
        } else {
            let baseUrl = request.configInfo?.baseUrl!
            let pathUrl = request.configInfo?.pathUrl!
            
            guard baseUrl != nil else { return }
            guard pathUrl != nil else { return }
            
            request.requestTask = sessionTaskForRequest(request, model)
        }
        
        assert(request.requestTask != nil, "requestTask should not be nil")
        addRequestToRecord(request)
        request.requestTask?.resume()
    }
    
    func sessionTaskForRequest<T: BaseMappable>(_ request: BaseRequest, _ model: T) -> URLSessionTask{
        
        let baseUrl = request.configInfo?.baseUrl
        let params: [String: Any]? = request.configInfo?.requestParams
        let pathUrl = request.configInfo?.pathUrl
        let url = URL.init(string: pathUrl!, relativeTo: URL(string: baseUrl!))
        
        var method = request.configInfo?.method
        if method == nil {
            method = HttpMethod.GET
        }
        
        var header = request.configInfo?.httpHeader
        if header == nil {
            header = SessionManager.defaultHTTPHeaders
        }
        
        /// set timeout, default 60 sec
        if let timeout = request.requestTimeout {
            SessionManager.default.session.configuration.timeoutIntervalForRequest = timeout
        } else {
            SessionManager.default.session.configuration.timeoutIntervalForRequest = defaultTimeout
        }
        
        var paramsEncoding: ParameterEncoding?
        let encoding = request.configInfo?.encoding
        if encoding == .JSON {
            paramsEncoding = JSONEncoding.default
        } else {
            paramsEncoding = URLEncoding.default
        }
        
        switch method! {
        case .GET:
            return dataModelRequestTask(url!, .get, params, paramsEncoding!, header!, model)
        case .POST:
            return dataModelRequestTask(url!, .post, params, paramsEncoding!, header!, model)
        case .PUT:
            return dataModelRequestTask(url!, .put, params, paramsEncoding!, header!, model)
        case .DELETE:
            return dataModelRequestTask(url!, .delete, params, paramsEncoding!, header!, model)
        }
    }
    
    func dataModelRequestTask<T: BaseMappable>(_ url: URL, _ method: HTTPMethod, _ params: [String: Any]?, _ encoding: ParameterEncoding, _ header: [String: String], _ model: T) -> URLSessionTask {
        
        let requestData = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: header)
        requestData.responseString { [weak self] (response: DataResponse<String>) in
            self?.handleResponseModelResult(requestData.task!, response, model)
        }
        return requestData.task!
    }
    
    func handleResponseModelResult<T: BaseMappable>(_ task: URLSessionTask, _ response: DataResponse<String>, _ model: T) {
        lock.lock()
        let request: BaseRequest = self.recordRequests[task.taskIdentifier]!
        lock.unlock()
        
        request.responseData = response.data
        request.responseString = response.result.value
        request.error = response.result.error
        
        switch response.result {
        case .success(_):
            let type: ResponseType = (request.configInfo?.responseType)!
            switch type {
            case .array:
                request.modelData = Mapper<T>().mapArray(JSONString: response.result.value!)
                break
            case .dictionary:
                request.modelData = request.toDictionary(jsonString: response.result.value)
                break
            case .model:
                request.modelData = Mapper<T>().map(JSONString: response.result.value!)
                break
            case .string:
                request.modelData = response.result.value
                break
            }
            self.handleSuccessResult(request)
            break
            
        case .failure(_):
            self.handleFailureResult(request)
            break
        }
    }
}
