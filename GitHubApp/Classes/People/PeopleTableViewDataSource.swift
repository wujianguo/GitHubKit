//
//  PeopleTableViewDataSource.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit

class PeopleTableViewDataSource: PaginationTableViewDataSource<User> {

    override init(cellIdentifier: String, refreshControl: UIRefreshControl, firstRequest: AuthorizationRequest) {
        super.init(cellIdentifier: cellIdentifier, refreshControl: refreshControl, firstRequest: firstRequest)
    }

}
