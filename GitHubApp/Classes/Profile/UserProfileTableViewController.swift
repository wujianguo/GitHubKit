//
//  UserProfileTableViewController.swift
//  GitHubKit
//
//  Created by wujianguo on 16/8/24.
//
//

import UIKit
import GitHubKit


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
            }
        }
    }

    var isFollowing: Bool? {
        didSet {

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
        let segmentedControl = UISegmentedControl(items: [NSLocalizedString("Followers", comment: ""), NSLocalizedString("Starred", comment: ""), NSLocalizedString("Following", comment: "")])
        segmentedControl.addTarget(self, action: #selector(UserProfileTableViewController.segmentedControlValueChanged(_:)), forControlEvents: .ValueChanged)
        navigationItem.titleView = segmentedControl
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        refreshControl?.beginRefreshing()
        tableView.dataSource = dataSource
        dataSource.firstRequest = GitHubKit.userReposRequest(self.user!.login!)
        tableView.registerClass(RepositoryTableViewCell.self, forCellReuseIdentifier: RepositoryTableViewCell.cellIdentifier)
        dataSource.refresh(tableView)

//        title = "\(user!.name!)"
    }

    lazy var dataSource: RepositoryTableViewDataSource = {
        let ds = RepositoryTableViewDataSource(cellIdentifier: RepositoryTableViewCell.cellIdentifier, refreshControl: self.refreshControl!, firstRequest: GitHubKit.userReposRequest(self.user!.login!))
        return ds
    }()

    func refresh() {
        dataSource.refresh(tableView)
    }

    func segmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            performToFollowers()
        } else if sender.selectedSegmentIndex == 1 {
            performToStarred()
        } else if sender.selectedSegmentIndex == 2 {
            performToFollowing()
        }
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
