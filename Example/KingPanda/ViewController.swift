//
//  ViewController.swift
//  KingPanda
//
//  Created by hsdoing@163.com on 04/11/2019.
//  Copyright (c) 2019 hsdoing@163.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = TestApi.init()
        api.startRequest(success: { (response) in
            debugPrint(response.modelData as? [String: Any] ?? [:])
        }) { (response) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

