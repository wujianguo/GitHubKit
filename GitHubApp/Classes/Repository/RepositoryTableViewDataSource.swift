//
//  RepositoryTableViewDataSource.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit

class RepositoryTableViewDataSource: PaginationTableViewDataSource<Repository> {

    override init(cellIdentifier: String, refreshControl: UIRefreshControl, firstRequest: AuthorizationRequest) {
        super.init(cellIdentifier: cellIdentifier, refreshControl: refreshControl, firstRequest: firstRequest)
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Repositories", comment: "")
    }
}
