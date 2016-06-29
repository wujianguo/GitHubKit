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
        GitHubKit.gistRequest("c72608339424e7284ad69a67583cfe8c").responseObject { (response: Response<Gist, NSError>) in
            debugPrint(response.result.value?.eTag)
            debugPrint(response.result.value?.lastModified)
            debugPrint(response.result.value?.created_at)
            debugPrint(response.result.value?.updated_at)
            debugPrint(response.result)
            debugPrint(response.result.value?.owner)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

