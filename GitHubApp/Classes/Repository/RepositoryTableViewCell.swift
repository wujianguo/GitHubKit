//
//  RepositoryTableViewCell.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/25.
//
//

import UIKit
import GitHubKit
import Kingfisher

protocol RepositoryTableViewCellDelegate: class {
    func repositoryTableViewCellPerformToProfile(repo: Repository)
    func repositoryTableViewCellPerformToRepo(repo: Repository)
}

class RepositoryTableViewCell: PaginationTableViewCell<Repository> {

    static let cellIdentifier = "RepositoryTableViewCellIdentifier"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    weak var delegate: RepositoryTableViewCellDelegate?

    let avatarButton = UIButton()
    let repoButton = UIButton()
    let descriptionLabel = UILabel()
    let starImageView = UIImageView()
    let starNumLabel = UILabel()

    override func setupUI() {
        super.setupUI()
        /*
        avatarButton.addTarget(self, action: #selector(RepositoryTableViewCell.performToUser), forControlEvents: .TouchUpInside)
        contentView.addSubview(avatarButton)
        avatarButton.snp_makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp_leadingMargin)
            make.top.equalTo(self.contentView.snp_topMargin)
            make.width.height.equalTo(50)
        }
        repoButton.addTarget(self, action: #selector(RepositoryTableViewCell.performToRepo), forControlEvents: .TouchUpInside)
        repoButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        contentView.addSubview(repoButton)
        repoButton.snp_makeConstraints { (make) in
            make.top.equalTo(avatarButton.snp_top)
            make.leading.equalTo(avatarButton.snp_trailing).offset(8)
        }
        contentView.addSubview(starImageView)
        starImageView.snp_makeConstraints { (make) in
            make.top.equalTo(avatarButton.snp_top)
            make.trailing.equalTo(self.contentView.snp_trailingMargin)
            make.centerY.equalTo(repoButton.snp_centerY)
        }
        contentView.addSubview(starNumLabel)
        starNumLabel.snp_makeConstraints { (make) in
            make.trailing.equalTo(starImageView.snp_trailingMargin)
            make.centerY.equalTo(starImageView.snp_centerY)
        }
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { (make) in
            make.top.equalTo(repoButton.snp_bottomMargin)
            make.leading.equalTo(repoButton.snp_leading)
            make.trailing.equalTo(self.contentView.snp_trailingMargin)
        }
        */
    }

    override func updateUI() {
        super.updateUI()
        textLabel?.text = item.full_name
        detailTextLabel?.text = item.description

//        repoButton.setTitle(item.full_name, forState: .Normal)
//        descriptionLabel.text = item.description
//        if let num = item.stargazers_count {
//            starNumLabel.text = "\(num)"
//        }
        if let url = item.profile?.avatar_url {
//            avatarButton.kf_cancelImageDownloadTask()
//            avatarButton.kf_setImageWithURL(NSURL(string: url), forState: .Normal, placeholderImage: UIImage.defaultAvatar)
            imageView?.kf_cancelDownloadTask()
            imageView?.kf_setImageWithURL(NSURL(string: url), placeholderImage: UIImage.defaultAvatar)
        }
    }

    func performToUser() {
        delegate?.repositoryTableViewCellPerformToProfile(item)
    }

    func performToRepo() {
        delegate?.repositoryTableViewCellPerformToRepo(item)
    }
}