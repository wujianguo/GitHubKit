//
//  FirstViewController.swift
//  GitHub
//
//  Created by wujianguo on 16/6/28.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import GitHubKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GitHubKit.req()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

