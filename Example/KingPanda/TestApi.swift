//
//  TestApi.swift
//  KingPanda_Example
//
//  Created by DomiDD on 2019/4/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import KingPanda

class TestApi: KingPanda {
    override init() {
        super.init()
        responseDataType = .dictionary
        requestMethod = .POST
        requestPathUrlString = ""
        requestBaseUrlString = ""
        requestParameters = [:]
    }
}
