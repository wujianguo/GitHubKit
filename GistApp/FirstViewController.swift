//
//  FirstViewController.swift
//  GistApp
//
//  Created by wujianguo on 16/6/28.
//
//

import UIKit
import GitHubKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GitHubKit.t()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

