//
//  RepositoriesTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/21.
//
//

import UIKit
import GitHubKit
import Alamofire
import ObjectMapper


class RepositoryTableViewCell: PaginationTableViewCell<Repository> {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    override func updateUI() {
        if let name = item.name {
            textLabel?.text = name
        }
        if let desc = item.description {
            detailTextLabel?.text = desc
        }
    }
    
}


class RepositoriesTableViewController: PaginationTableViewController<Repository> {

    override init(style: UITableViewStyle) {
        super.init(style: style)
        tabBarItem = UITabBarItem(title: NSLocalizedString("Repositories", comment: ""), image: UIImage(named: "repositories"), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Table view data source

    override var loginRequired: Bool {
        return true
    }
    
    override var firstRequest: AuthorizationRequest {
        return GitHubKit.currentUserReposRequest()
    }
    
    override var tableViewCellIdentifier: String {
        return "RepositoriesTableViewCellIdentifier"
    }

    override var tableViewCellClassType: AnyClass? {
        return RepositoryTableViewCell.self
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
