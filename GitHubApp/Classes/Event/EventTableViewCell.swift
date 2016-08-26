//
//  EventTableViewCell.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/26.
//
//

import UIKit
import GitHubKit

class EventTableViewCell: PaginationTableViewCell<Event> {

    static let cellIdentifier = "EventTableViewCellIdentifier"

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
            imageView?.kf_setImageWithURL(NSURL(string: avatar), placeholderImage: UIImage.defaultAvatar)
        }
    }
}
