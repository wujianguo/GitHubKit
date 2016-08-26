//
//  ProfileTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/21.
//
//

import UIKit
import SnapKit
import GitHubKit
import Kingfisher

extension Profile {
    var profileDescription: String? {
        if let user = self as? User {
            return user.bio
        } else if let org = self as? Organization {
            return org.description
        } else {
            return nil
        }
    }
}

extension UIImageView {
    func clipsAsAvatar() {
        layer.masksToBounds = true
        layer.cornerRadius = 4
    }
}

class ProfileHeadView: UIView {

    var isFollowing: Bool? {
        didSet {
            if let follow = isFollowing {
                followButton.selected = follow
            }
        }
    }

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.defaultAvatar)
        imageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(120)
        }
        imageView.clipsAsAvatar()
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle3)
        return label
    }()

    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        return label
    }()

    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        return label
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        return label
    }()

    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        return label
    }()

    lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        return label
    }()

    lazy var avatarHeadDescription: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.alignment = .Leading
        stackView.spacing = 4
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.loginLabel)
        stackView.addArrangedSubview(self.companyLabel)
        stackView.addArrangedSubview(self.locationLabel)
        stackView.addArrangedSubview(self.emailLabel)
        stackView.addArrangedSubview(self.linkLabel)
        return stackView
    }()

    lazy var avatarHead: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.distribution = .Fill
        stackView.spacing = 8
        stackView.addArrangedSubview(self.avatarImageView)
        stackView.addArrangedSubview(self.avatarHeadDescription)
        return stackView
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        return label
    }()

    lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Follow", comment: ""), forState: .Normal)
        button.setTitle(NSLocalizedString("Unfollow", comment: ""), forState: .Selected)
        button.addTarget(self, action: #selector(ProfileHeadView.followButtonClick(_:)), forControlEvents: .TouchUpInside)
        return button
    }()

    lazy var followersButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Followers", comment: ""), forState: .Normal)
//        button.addTarget(self, action: #selector(ProfileHeadView.performToFollowers), forControlEvents: .TouchUpInside)
        return button
    }()

    lazy var followingButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Following", comment: ""), forState: .Normal)
//        button.addTarget(self, action: #selector(ProfileHeadView.performToFollowing), forControlEvents: .TouchUpInside)
        return button
    }()

    lazy var starredButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Starred", comment: ""), forState: .Normal)
//        button.addTarget(self, action: #selector(ProfileHeadView.performToStarred), forControlEvents: .TouchUpInside)
        return button
    }()

    lazy var vcardStats: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Horizontal
        stackView.alignment = .Center
        stackView.distribution = .FillEqually
        stackView.addArrangedSubview(self.followersButton)
        stackView.addArrangedSubview(self.starredButton)
        stackView.addArrangedSubview(self.followingButton)
        return stackView
    }()

    lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
//        stackView.alignment = .Leading
//        stackView.distribution = .Fill
        stackView.spacing = 8
//        stackView.layoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(self.avatarHead)
        stackView.addArrangedSubview(self.descriptionLabel)
        stackView.addArrangedSubview(self.followButton)
        stackView.addArrangedSubview(self.vcardStats)
        return stackView
    }()

    func updateUI(profile: Profile) {
        backgroundColor = UIColor.grayColor()
        contentView.removeFromSuperview()
        addSubview(contentView)
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }

        if let urlstr = profile.avatar_url, url = NSURL(string: urlstr) {
            avatarImageView.kf_cancelDownloadTask()
            avatarImageView.kf_setImageWithURL(url)
        }
        if let name = profile.name {
            nameLabel.text = name
        }
        if let login = profile.login {
            loginLabel.text = login
        }
        if let company = profile.company {
            companyLabel.text = company
        }
        if let location = profile.location {
            locationLabel.text = location
        }
        if let email = profile.email {
            emailLabel.text = email
        }
        if let link = profile.blog {
            linkLabel.text = link
        }
        if let des = profile.profileDescription {
            descriptionLabel.text = des
        }
    }

    func followButtonClick(sender: UIButton) {
        sender.selected = !sender.selected
    }

    /*
    func performToFollowers() {

    }

    func performToStarred() {

    }

    func performToFollowing() {

    }
    */
}

class ProfileTableViewController: UITableViewController, RepositoryTableViewCellDelegate {

    var profileView: ProfileHeadView!
    var profile: Profile? {
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView = ProfileHeadView(frame: CGRectMake(0, 0, 1, 280))
        tableView.tableHeaderView = profileView
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? RepositoryTableViewCell {
            cell.delegate = self
        }
    }

    func repositoryTableViewCellPerformToRepo(repo: Repository) {
        let vc = RepositoryViewController(repo: repo)
        navigationController?.pushViewController(vc, animated: true)
    }

    func repositoryTableViewCellPerformToProfile(repo: Repository) {
//        guard repo.profile?.login != profile?.login else { return }
//        var vc: ProfileTableViewController?
//        if let user = repo.user {
//            vc = UserProfileTableViewController(user: user)
//        } else if let org = repo.organization {
//            vc = OrganizationTableViewController(org: org)
//        }
//        if let v = vc {
//            navigationController?.pushViewController(v, animated: true)
//        }
    }
}
