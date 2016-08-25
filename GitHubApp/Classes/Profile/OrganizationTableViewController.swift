//
//  OrganizationTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/24.
//
//

import UIKit
import GitHubKit

class OrganizationTableViewController: ProfileTableViewController {

    var org: Organization! = nil
    init(org: Organization) {
        super.init(style: .Grouped)
        self.org = org
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
//        tableView.registerClass(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)
    }

    lazy var dataSource: RepositoryTableViewDataSource = {
        let ds = RepositoryTableViewDataSource(cellIdentifier: RepositoryTableViewCell.cellIdentifier, refreshControl: self.refreshControl!, firstRequest: GitHubKit.orgReposRequest(self.org.login!))
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }
}
