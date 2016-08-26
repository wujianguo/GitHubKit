//
//  ExploreTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/21.
//
//

import UIKit
import GitHubKit

extension String {
    static var exploreTitle: String {
        return NSLocalizedString("Explore", comment: "")
    }
}

class ExploreTableViewController: UITableViewController {

    override init(style: UITableViewStyle) {
        super.init(style: style)
        tabBarItem = UITabBarItem(title: String.exploreTitle, image: UIImage(named: "explore"), tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String.exploreTitle
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()

        tableView.dataSource = dataSource
        tableView.registerClass(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)
    }

    lazy var dataSource: RepositoriesTableViewDataSource = {
        let ds = RepositoriesTableViewDataSource(cellIdentifier: RepositoryTableViewCell.cellIdentifier, refreshable: self.refreshControl!, firstRequest: GitHubKit.currentUserReposRequest())
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }

}
