//
//  BaseRequest.swift
//  CityPartner
//
//  Created by PEACEMINUSONE on 2018/4/28.
//  Copyright © 2018年 com.pinguo. All rights reserved.
//

import Foundation
import ObjectMapper

open class BaseRequest {
    
    ///request success or fail closure
    open var requestSuccessed: responseClosure?
    open var requestFailed: responseClosure?
    
    ///delegate, return response
    open var delegate: ResponseProtocol?
    open var configInfo: NetworkConfigInfo?
    
    open var requestTask: URLSessionTask?
    
    open var responseData: Data?
    open var responseString: String?
    open var responseObject: Any?
    open var modelData: Any?
    
    open var error: Error?
    open var excuting: Bool?
    open var canceled: Bool?
    open var requestTimeout: TimeInterval?
    
    public init() {
        requestTimeout = 30
    }
    
    ///covert Json string to Dictionary
    open func toDictionary(jsonString: String?) -> [String: Any]? {
        
        guard jsonString != nil else { return nil }
        
        if let data = jsonString?.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

// MARK: method
extension BaseRequest {
    
    ///use closure pattern to request network
    public func startRequestWithClosure(successed: @escaping responseClosure, failed: @escaping responseClosure) {
        requestSuccessed = successed;
        requestFailed = failed;
        self.start()
    }
    
    ///use delegate pattern request network
    public func start() {
        NetworkManager.sharedInstance.addRequest(self)
    }
    
    ///stop current request task
    public func stop() {
        delegate = nil
        NetworkManager.sharedInstance.cancelRequest(self)
    }
    
    ///response custom model data
    public func start<T: BaseMappable>(withModel model: T) {
        NetworkManager.sharedInstance.addRequest(self, model)
    }
}

