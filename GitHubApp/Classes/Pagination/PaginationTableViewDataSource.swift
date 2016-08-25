//
//  PaginationTableViewDataSource.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit
import ObjectMapper
import Alamofire

class PaginationTableViewDataSource<T: Mappable>: NSObject, UITableViewDataSource {

    init(cellIdentifier: String, refreshControl: UIRefreshControl, firstRequest: AuthorizationRequest) {
        super.init()
        self.cellIdentifier = cellIdentifier
        self.refreshControl = refreshControl
        self.firstRequest = firstRequest
    }

    var firstRequest: AuthorizationRequest! = nil

    var loginRequired: Bool {
        return false
    }

    var cellIdentifier: String = ""
    
    var refreshControl: UIRefreshControl?


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        if let c = cell as? PaginationTableViewCell<T> {
            c.item = items[indexPath.row]
        }
        if indexPath.row == items.count - 1 {
            paginationNext(tableView)
        }
        return cell
    }

    var items = [T]()
    var firstPage: String?
    var lastPage: String?
    var nextPage: String?

    var firstPageEtag: String?
    var firstPageLastModified: NSDate?

    var currentRequest: AuthorizationRequest?

    func paginationNext(tableView: UITableView) {
        guard !refreshControl!.refreshing else { return }
        guard nextPage != nil else { return }

        if let current = currentRequest?.url {
            if current == lastPage || current == nextPage {
                return
            }
        }
        currentRequest?.cancel()
        currentRequest = AuthorizationRequest(url: nextPage!, loginRequired: loginRequired)

        currentRequest!.responseArray { (response: Response<GitHubArray<T>, NSError>) in
            if let ret = response.result.value {
                if self.items.count == 0 {
                    self.firstPageEtag = ret.eTag
                    self.firstPageLastModified = ret.lastModified
                }
                var indexPaths = [NSIndexPath]()
                for i in 0..<ret.array.count {
                    indexPaths.append(NSIndexPath(forRow: i + self.items.count, inSection: 0))
                }
                self.items.appendContentsOf(ret.array)
                if let link = ret.firstPageLink {
                    self.firstPage = link
                }
                if let link = ret.lastPageLink {
                    self.lastPage = link
                }
                if let link = ret.nextPageLink {
                    self.nextPage = link
                }
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
            }
        }
    }

    func refresh(tableView: UITableView) {
        guard refreshControl!.refreshing else { return }
        currentRequest?.cancel()
        currentRequest = AuthorizationRequest(url: firstRequest.url, eTag: firstPageEtag, lastModified: firstPageLastModified, loginRequired: loginRequired)
        currentRequest!.responseArray { (response: Response<GitHubArray<T>, NSError>) in
            self.refreshControl?.endRefreshing()
            if let ret = response.result.value {
                self.firstPageEtag = ret.eTag
                self.firstPageLastModified = ret.lastModified
                self.items = ret.array
                if let link = ret.firstPageLink {
                    self.firstPage = link
                }
                if let link = ret.lastPageLink {
                    self.lastPage = link
                }
                self.nextPage = ret.nextPageLink
                tableView.reloadData()
            }
        }
    }

}
