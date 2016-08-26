//
//  OrganizationTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/24.
//
//

import UIKit
import GitHubKit
import ObjectMapper
import Alamofire

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
        title = org.name
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()

        tableView.dataSource = dataSource
        tableView.registerClass(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.cellIdentifier)
//        tableView.registerClass(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)
        if let name = org.name {
            title = name
        } else {
            org.updateSelfRequest().responseObject { (response: Response<Organization, NSError>) in
                guard response.result.isSuccess else { return }
                self.org.eTag = response.result.value?.eTag
                self.org.lastModified = response.result.value?.lastModified
                if let json = response.result.value?.toJSON() {
                    self.org.mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
                    self.profileView.updateUI(self.org)
                    self.title = self.org.name
                }
            }
        }
        profileView.updateUI(org)
    }

    lazy var dataSource: RepositoriesTableViewDataSource = {
        let ds = RepositoriesTableViewDataSource(cellIdentifier: RepositoryTableViewCell.cellIdentifier, refreshable: self.refreshControl!, firstRequest: GitHubKit.orgReposRequest(self.org.login!))
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }

}
