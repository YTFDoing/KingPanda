//
//  Request.swift
//  CityPartner
//
//  Created by PEACEMINUSONE on 2018/4/29.
//  Copyright © 2018年 com.pinguo. All rights reserved.
//

import UIKit
import ObjectMapper

open class Request: BaseRequest {

    ///networkConfigInfo protocol
    open var responseDataType: ResponseType?
    open var requestMethod: HttpMethod?
    open var requestBaseUrlString: String?
    open var requestPathUrlString: String?
    open var requestCustomUrlString: String?
    open var requestParameters: [String : Any]?
    open var requestHttpHeaders: [String : String]?
    
    //cache data
    open var useCache: Bool
    
    public override init() {
        useCache = false
        super.init()
        configInfo = self
    }
}

//MARK: Method
extension Request {
    
    public func startRequest(success: @escaping responseClosure, fail failure: @escaping responseClosure) {
        startRequestWithClosure(successed: success, failed: failure);
    }
    
    public func startRequest<T: BaseMappable>(model: T, success: @escaping responseClosure, failure: @escaping responseClosure) {
        requestSuccessed = success;
        requestFailed = failure;
        start(withModel: model)
    }
}

//MARK: NetworkConfigInfo protocol
extension Request: NetworkConfigInfo {
    public var responseType: ResponseType? {
        return responseDataType
    }
    
    public var method: HttpMethod? {
        return requestMethod
    }
    
    public var baseUrl: String? {
        return requestBaseUrlString
    }
    
    public var pathUrl: String? {
        return requestPathUrlString
    }
    
    public var customRequestUrl: String? {
        return requestCustomUrlString
    }
    
    public var requestParams: [String : Any]? {
        return requestParameters
    }
    
    public var httpHeader: [String : String]? {
        return requestHttpHeaders
    }
}
