//
//  NetworkUtil.swift
//  CityPartner
//
//  Created by PEACEMINUSONE on 2018/4/29.
//  Copyright © 2018年 com.pinguo. All rights reserved.
//

import Foundation

public typealias callback = () -> Void
public typealias successCallBack = (_ data: Any?) -> Void
public typealias failedCallBack = (_ error: Error?) -> Void
public typealias Arguments = [String: Any]
public typealias responseClosure = (_ request: BaseRequest) -> Void

/// request type
public enum HttpMethod {
    case GET
    case POST
    case PUT
    case DELETE
}

public enum ResponseType {
    case array
    case dictionary
    case model
    case string
}

public protocol NetworkConfigInfo {
    
    var responseType: ResponseType? { get }
    var method: HttpMethod? { get }
    var baseUrl: String? { get }
    var pathUrl: String? { get }
    var customRequestUrl: String? { get }
    var requestParams: [String: Any]? { get }
    var httpHeader: [String: String]? { get }
}

/// request call back
public protocol ResponseProtocol {
    func requestSuccess(_ result: BaseRequest)
    func requestFailure(_ result: BaseRequest)
    func requestSuccessWithModel(_ model: Any?)
}


