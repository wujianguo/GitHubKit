//
//  EventsTabelViewDataSource.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/26.
//
//

import UIKit
import GitHubKit

class EventsTableViewDataSource: PaginationTableViewDataSource<Event> {

    override init(cellIdentifier: String, refreshable: PaginationTableViewDataSourceRefreshable, firstRequest: AuthorizationRequest) {
        super.init(cellIdentifier: cellIdentifier, refreshable: refreshable, firstRequest: firstRequest)
    }

}
