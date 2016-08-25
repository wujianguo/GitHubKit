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

class ProfileHeadView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: CGRectZero)
        setupUI()
    }

    var isFollowing: Bool? {
        didSet {

        }
    }

    var avatarImageView = UIImageView()
    var loginLabel = UILabel()

    func setupUI() {
        addSubview(avatarImageView)
        avatarImageView.snp_makeConstraints { (make) in
            make.leading.equalTo(self.snp_leadingMargin)
            make.top.equalTo(self.snp_topMargin)
            make.width.height.equalTo(120)
        }

        addSubview(loginLabel)
        loginLabel.snp_makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp_topMargin)
            make.leading.equalTo(avatarImageView.snp_leadingMargin)
        }
    }

    var contentView = UIStackView()
    func updateUI(profile: Profile) {
        contentView.removeFromSuperview()
        addSubview(contentView)
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
