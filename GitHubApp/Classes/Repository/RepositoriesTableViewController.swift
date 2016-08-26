//
//  RepositoriesTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/21.
//
//

import UIKit
import GitHubKit


class RepositoriesTableViewController: UITableViewController, RepositoryTableViewCellDelegate {

    var firstRequest: AuthorizationRequest! = nil
    init(firstRequest: AuthorizationRequest) {
        super.init(style: .Grouped)
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
        tableView.registerClass(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)

        tableView.rowHeight = 120
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }

    lazy var dataSource: RepositoriesTableViewDataSource = {
        let ds = RepositoriesTableViewDataSource(cellIdentifier: RepositoryTableViewCell.cellIdentifier, refreshable: self.refreshControl!, firstRequest: self.firstRequest)
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? RepositoryTableViewCell {
            cell.delegate = self
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = RepositoryViewController(repo: dataSource.items[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

    func repositoryTableViewCellPerformToRepo(repo: Repository) {
        let vc = RepositoryViewController(repo: repo)
        navigationController?.pushViewController(vc, animated: true)
    }

    func repositoryTableViewCellPerformToProfile(repo: Repository) {
        var vc: ProfileTableViewController?
        if let user = repo.user {
            vc = UserProfileTableViewController(user: user)
        } else if let org = repo.organization {
            vc = OrganizationTableViewController(org: org)
        }
        if let v = vc {
            navigationController?.pushViewController(v, animated: true)
        }
    }
}
