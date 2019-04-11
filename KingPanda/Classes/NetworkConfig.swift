//
//  YJNetworkConfig.swift
//  CityPartner
//
//  Created by PEACEMINUSONE on 2018/4/28.
//  Copyright © 2018年 com.pinguo. All rights reserved.
//

import Foundation

open class NetworkConfig {
    
    static public let shared = NetworkConfig()
    
    ///this is domain name
    open var baseUrl: String?
    
    ///save base url arry
    open var baseUrls: [String]?
    
    ///save base url dictionary
    open var baseUrlDict: [String: Any]?
    
    //public parameters
    open var publicParams: [String: Any]?
    
}
