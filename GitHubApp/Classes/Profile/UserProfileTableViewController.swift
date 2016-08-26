//
//  UserProfileTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/24.
//
//

import UIKit
import GitHubKit
import Alamofire
import ObjectMapper

class UserProfileTableViewController: ProfileTableViewController {

    var user: User?
    init(user: User?) {
        super.init(style: .Grouped)
        self.user = user
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserProfileTableViewController.handleCurrentUserInfoNotification(_:)), name: GitHubCurrentUserInfoNotificationName, object: nil)
            if GitHubKit.currentUser == nil {
                GitHubKit.login()
            } else {
                user = GitHubKit.currentUser
                setupUI()
            }
        } else {
            setupUI()
            if user?.login != GitHubKit.currentUser?.login {
                checkfollowUserRequest(user!.login!).responseBoolen { (response) in
                    self.isFollowing = response.result.value
                }
                if let name = user?.name {
                    title = name
                } else {
                    user?.updateSelfRequest().responseObject { (response: Response<User, NSError>) in
                        guard response.result.isSuccess else { return }
                        self.user?.eTag = response.result.value?.eTag
                        self.user?.lastModified = response.result.value?.lastModified
                        if let json = response.result.value?.toJSON() {
                            self.user?.mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
                            self.profileView.updateUI(self.user!)
                            self.title = self.user?.name
                        }
                    }
                }
            }
        }
    }

    var isFollowing: Bool? {
        didSet {
            profileView.isFollowing = isFollowing
        }
    }

    func handleCurrentUserInfoNotification(notification: NSNotification) {
        user = GitHubKit.currentUser
        setupUI()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: GitHubCurrentUserInfoNotificationName, object: nil)
    }

    func setupUI() {
        profileView.updateUI(user!)
        profileView.followersButton.addTarget(self, action: #selector(UserProfileTableViewController.performToFollowers), forControlEvents: .TouchUpInside)
        profileView.followingButton.addTarget(self, action: #selector(UserProfileTableViewController.performToFollowing), forControlEvents: .TouchUpInside)
        profileView.starredButton.addTarget(self, action: #selector(UserProfileTableViewController.performToStarred), forControlEvents: .TouchUpInside)

        if user?.name == GitHubKit.currentUser?.name {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(UserProfileTableViewController.performToSettings))
        }

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        tableView.dataSource = dataSource
        dataSource.firstRequest = GitHubKit.userReposRequest(self.user!.login!)
        tableView.registerClass(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)
    }

    lazy var dataSource: RepositoriesTableViewDataSource = {
        let ds = RepositoriesTableViewDataSource(cellIdentifier: RepositoryTableViewCell.cellIdentifier, refreshable: self.refreshControl!, firstRequest: GitHubKit.userReposRequest(self.user!.login!))
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }

    func performToSettings() {
        let vc = SettingsTableViewController(style: .Grouped)
        navigationController?.pushViewController(vc, animated: true)
    }

    func performToFollowers() {
        if let request = user?.followersRequest() {
            let vc = PeopleTableViewController(firstRequest: request)
            vc.title = NSLocalizedString("Followers", comment: "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func performToFollowing() {
        if let request = user?.followingRequest() {
            let vc = PeopleTableViewController(firstRequest: request)
            vc.title = NSLocalizedString("Following", comment: "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func performToStarred() {
        if let request = user?.starredRequest() {
            let vc = RepositoriesTableViewController(firstRequest: request)
            vc.title = NSLocalizedString("Starred", comment: "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func follow() {
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = RepositoryViewController(repo: dataSource.items[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
