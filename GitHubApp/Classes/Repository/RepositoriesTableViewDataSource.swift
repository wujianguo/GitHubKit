//
//  RepositoryTableViewDataSource.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit

class RepositoriesTableViewDataSource: PaginationTableViewDataSource<Repository> {

    override init(cellIdentifier: String, refreshable: PaginationTableViewDataSourceRefreshable, firstRequest: AuthorizationRequest) {
        super.init(cellIdentifier: cellIdentifier, refreshable: refreshable, firstRequest: firstRequest)
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("Repositories", comment: "")
    }
}
