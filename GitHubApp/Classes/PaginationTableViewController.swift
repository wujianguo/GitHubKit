//
//  PaginationTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/24.
//
//

import UIKit
import GitHubKit
import Alamofire
import ObjectMapper

class PaginationTableViewCell<T: Mappable>: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var item: T! = nil {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        
    }
}


class PaginationTableViewController<T: Mappable>: UITableViewController {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(PaginationTableViewCell<T>.self, forCellReuseIdentifier: tableViewCellIdentifier)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        paginationNext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    var firstRequest: Request! {
        return nil
    }

    var items = [T]()
    var firstPage: String?
    var lastPage: String?
    var nextPage: String?
    
    var firstPageEtag: String?
    var firstPageLastModified: NSDate?
    
    var currentRequest: Request?
    
    func paginationNext() {
        guard firstRequest != nil else { return }
        
        var url: String?
        if let next = nextPage {
            url = GitHubKit.request(next).request?.URL?.absoluteString
        } else {
            url = firstRequest.request?.URL?.absoluteString
        }

        if let current = currentRequest?.request?.URL?.absoluteString {
            if current == lastPage || current == url {
                return
            }
        }
        currentRequest?.cancel()
        currentRequest = GitHubKit.request(url!)

        currentRequest!.responseArray { (response: Response<GitHubArray<T>, NSError>) in
            if let events = response.result.value {
                if self.items.count == 0 {
                    self.firstPageEtag = events.eTag
                    self.firstPageLastModified = events.lastModified
                }
                self.items.appendContentsOf(events.array)
                if let link = events.firstPageLink {
                    self.firstPage = link
                }
                if let link = events.lastPageLink {
                    self.lastPage = link
                }
                if let link = events.nextPageLink {
                    self.nextPage = link
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func refresh() {
        refreshControl?.endRefreshing()
        if let lastModified = self.firstPageLastModified {
            
        }
    }
    
    var tableViewCellIdentifier: String {
        return ""
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath)
            
        if let c = cell as? PaginationTableViewCell<T> {
            c.item = items[indexPath.row]
        }
        if indexPath.row == items.count - 1 {
            paginationNext()
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
