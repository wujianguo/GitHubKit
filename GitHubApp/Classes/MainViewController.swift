//
//  MainViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/24.
//
//

import UIKit


class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        let newsNav = UINavigationController(rootViewController: NewsTableViewController(style: .Plain))
        let repoNav = UINavigationController(rootViewController: RepositoriesTableViewController(style: .Plain))
        
        let exploreNav = UIStoryboard(name: "Explore", bundle: nil).instantiateInitialViewController()!
        let profileNav = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController()!
        viewControllers = [newsNav, repoNav, exploreNav, profileNav]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
