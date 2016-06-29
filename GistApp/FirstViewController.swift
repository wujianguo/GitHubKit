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
        /*
        GitHubKit.gistRequest("ef8dfed711d9d52ee7ab18bd3d17f815").responseObject { (response: Response<Gist, NSError>) in
            debugPrint(response.result.value?.eTag)
            debugPrint(response.result.value?.lastModified)
            debugPrint(response.result.value?.created_at)
            debugPrint(response.result.value?.updated_at)
            debugPrint(response.result)
            if let history = response.result.value?.history {
                for h in history {
                    debugPrint(h.url)
                    debugPrint(h.version)
                    debugPrint(h.user?.avatar_url)
                }
            }
        }
        */
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

