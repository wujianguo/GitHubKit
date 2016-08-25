//
//  PeopleTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit

class PeopleTableViewController: UITableViewController {

    var firstRequest: AuthorizationRequest! = nil
    init(firstRequest: AuthorizationRequest) {
        super.init(style: .Plain)
        self.firstRequest = firstRequest
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()

        tableView.dataSource = dataSource
        tableView.registerClass(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)
    }

    lazy var dataSource: PeopleTableViewDataSource = {
        let ds = PeopleTableViewDataSource(cellIdentifier: PersonTableViewCell.cellIdentifier, refreshControl: self.refreshControl!, firstRequest: self.firstRequest)
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }
}
