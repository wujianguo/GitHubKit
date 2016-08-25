//
//  PersonTableViewCell.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit
import Kingfisher

extension UIImage {
    static var defaultAvatar: UIImage {
        return UIImage(named: "default-avatar")!
    }
}

class PersonTableViewCell: PaginationTableViewCell<User> {

    static let cellIdentifier = "PersonTableViewCellIdentifier"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    override func updateUI() {
        textLabel?.text = item.login
        detailTextLabel?.text = item.name
        if let url = item.avatar_url {
            imageView?.kf_cancelDownloadTask()
            imageView?.kf_setImageWithURL(NSURL(string: url), placeholderImage: UIImage.defaultAvatar)
        }
    }
}
