//
//  FirstViewController.swift
//  GistApp
//
//  Created by wujianguo on 16/6/28.
//
//

import UIKit
import GitHubKit
import Alamofire
import ObjectMapper

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        rootEndpointRequest().responseObject { (response: Response<RootEndpoint, NSError>) in
            print(response.result.value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

