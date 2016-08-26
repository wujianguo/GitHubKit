//
//  MainViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/24.
//
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}

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
        let newsNav = BaseNavigationController(rootViewController: NewsTableViewController(style: .Plain))
        let exploreNav = BaseNavigationController(rootViewController: ExploreTableViewController(style: .Plain))
        let profileNav = BaseNavigationController(rootViewController: UserProfileTableViewController(style: .Grouped))
        profileNav.tabBarItem = UITabBarItem(title: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "profile"), tag: 0)
        profileNav.visibleViewController?.title = NSLocalizedString("Profile", comment: "")
        viewControllers = [newsNav, exploreNav, profileNav]
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
