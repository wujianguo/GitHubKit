//
//  NewsTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/21.
//
//

import UIKit
import GitHubKit

extension String {
    static var newsTitle: String {
        return NSLocalizedString("News", comment: "")
    }
}

class NewsTableViewController: UITableViewController {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tabBarItem = UITabBarItem(title: String.newsTitle, image: UIImage(named: "news"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.newsTitle
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()

        tableView.dataSource = dataSource
        tableView.registerClass(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsTableViewController.handleCurrentUserInfoNotification(_:)), name: GitHubCurrentUserInfoNotificationName, object: nil)
    }

    func handleCurrentUserInfoNotification(notification: NSNotification) {
        dataSource.firstRequest = GitHubKit.userReceivedEventsRequest(GitHubKit.currentUser!.login!)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: GitHubCurrentUserInfoNotificationName, object: nil)
    }

    lazy var dataSource: EventsTableViewDataSource = {
        var request: AuthorizationRequest?
        if let user = GitHubKit.currentUser {
            request = GitHubKit.userReceivedEventsRequest(GitHubKit.currentUser!.login!)
        } else {
            request = GitHubKit.publicEventsRequest()
        }
        let ds = EventsTableViewDataSource(cellIdentifier: EventTableViewCell.cellIdentifier, refreshable: self.refreshControl!, firstRequest: request!)
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }
    
}
