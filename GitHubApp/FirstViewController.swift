//
//  FirstViewController.swift
//  GitHubApp
//
//  Created by wujianguo on 16/7/20.
//
//

import UIKit
import GitHubKit
import Alamofire
import ObjectMapper

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GitHubKit.gistRequest().responseArray { (response: Response<[Gist], NSError>) in
            if let gists = response.result.value {
                for g in gists {
                    debugPrint(g.owner?.url)
                    debugPrint(g.owner?.avatar_url)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

