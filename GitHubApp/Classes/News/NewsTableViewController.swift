//
//  NewsTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/21.
//
//

import UIKit
import GitHubKit
import Alamofire
import ObjectMapper
import Kingfisher

class NewsTableViewCell: PaginationTableViewCell<Event> {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    override func updateUI() {
        if let name = item.actor?.login {
            textLabel?.text = name
        } else if let name = item.org?.login {
            textLabel?.text = name
        }
        if let repoName = item.repo?.name {
            detailTextLabel?.text = repoName
        }
        if let avatar = item.actor?.avatar_url {
            imageView?.kf_cancelDownloadTask()
            imageView?.kf_setImageWithURL(NSURL(string: avatar), placeholderImage: UIImage(named: "default-avatar"))
        }
    }
}


class NewsTableViewController: PaginationTableViewController<Event> {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tabBarItem = UITabBarItem(title: NSLocalizedString("News", comment: ""), image: UIImage(named: "news"), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("News", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
        
    override var firstRequest: AuthorizationRequest {
        return GitHubKit.publicEventsRequest()
    }
    
    override var tableViewCellIdentifier: String {
        return "NewsTableViewCellIdentifier"
    }

    override var tableViewCellClassType: AnyClass? {
        return NewsTableViewCell.self
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
