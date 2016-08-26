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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    weak var delegate: RepositoryTableViewCellDelegate?

    lazy var ownerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(RepositoryTableViewCell.performToProfile), forControlEvents: .TouchUpInside)
        button.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        return button
    }()

    lazy var repoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(RepositoryTableViewCell.performToRepo), forControlEvents: .TouchUpInside)
        button.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        return button
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        return label
    }()

    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
        return label
    }()

    lazy var forkNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
        return label
    }()

    lazy var starNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)
        return label
    }()

    lazy var forkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fork"))
        imageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(16)
        }
        return imageView
    }()

    lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.snp_makeConstraints { (make) in
            make.width.height.equalTo(16)
        }
        return imageView
    }()

    override func setupUI() {
        super.setupUI()
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.alignment = .Leading
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(4, 8, 4, 8))
        }

        let top = UIStackView()
        top.axis = .Horizontal
        top.addArrangedSubview(ownerButton)
        let label = UILabel()
        label.text = "/"
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        top.addArrangedSubview(label)
        top.addArrangedSubview(repoButton)

        let bottom = UIStackView()
        bottom.spacing = 4
        bottom.axis = .Horizontal
        bottom.addArrangedSubview(languageLabel)
        bottom.addArrangedSubview(starNumLabel)
        bottom.addArrangedSubview(starImageView)
        bottom.addArrangedSubview(forkNumLabel)
        bottom.addArrangedSubview(forkImageView)

        stackView.addArrangedSubview(top)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(bottom)
    }

    override func updateUI() {
        super.updateUI()
        ownerButton.setTitle(item.profile?.login, forState: .Normal)
        repoButton.setTitle(item.name, forState: .Normal)
        descriptionLabel.text = item.description
        languageLabel.text = item.language
        if let count = item.stargazers_count {
            starNumLabel.text = "\(count)"
        }
        if let count = item.forks_count {
            forkNumLabel.text = "\(count)"
        }
    }

    func performToProfile() {
        delegate?.repositoryTableViewCellPerformToProfile(item)
    }

    func performToRepo() {
        delegate?.repositoryTableViewCellPerformToRepo(item)
    }
}


class MixedRepositoryTableViewCell: PaginationTableViewCell<Repository> {

    static let cellIdentifier = "MixedRepositoryTableViewCellIdentifier"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}

class UserRepositoryTableViewCell: PaginationTableViewCell<Repository> {

    static let cellIdentifier = "UserRepositoryTableViewCellIdentifier"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
