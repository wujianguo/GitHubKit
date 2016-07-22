//
//  Repository.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/22.
//
//

import Foundation
import Alamofire
import ObjectMapper

public class Repository: GitHubObject {

    public var id: String?
    public var name: String?
    public var full_name: String?
    public var description: String?
    public var `private`: Bool?
    public var fork: Bool?
    public var url: String?
    public var html_url: String?
    public var archive_url: String?
    public var assignees_url: String?
    public var blobs_url: String?
    public var branches_url: String?
    public var clone_url: String?
    public var collaborators_url: String?
    public var comments_url: String?
    public var commits_url: String?
    public var compare_url: String?
    public var contents_url: String?
    public var contributors_url: String?
    public var deployments_url: String?
    public var downloads_url: String?
    public var events_url: String?
    public var forks_url: String?
    public var git_commits_url: String?
    public var git_refs_url: String?
    public var git_tags_url: String?
    public var git_url: String?
    public var hooks_url: String?
    public var issue_comment_url: String?
    public var issue_events_url: String?
    public var issues_url: String?
    public var keys_url: String?
    public var labels_url: String?
    public var languages_url: String?
    public var merges_url: String?
    public var milestones_url: String?
    public var mirror_url: String?
    public var notifications_url: String?
    public var pulls_url: String?
    public var releases_url: String?
    public var ssh_url: String?
    public var stargazers_url: String?
    public var statuses_url: String?
    public var subscribers_url: String?
    public var subscription_url: String?
    public var svn_url: String?
    public var tags_url: String?
    public var teams_url: String?
    public var trees_url: String?
    public var homepage: String?
    public var language: String?
    public var forks_count: Int?
    public var stargazers_count: Int?
    public var watchers_count: Int?
    public var size: Int?
    public var default_branch: String?
    public var open_issues_count: Int?
    public var has_issues: Bool?
    public var has_wiki: Bool?
    public var has_pages: Bool?
    public var has_downloads: Bool?
    public var pushed_at: NSDate?
    public var created_at: NSDate?
    public var updated_at: NSDate?


    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        id                  <- map["id"]
        name                <- map["name"]
        full_name           <- map["full_name"]
        description         <- map["description"]
        `private`           <- map["private"]
        fork                <- map["fork"]
        url                 <- map["url"]
        html_url            <- map["html_url"]
        archive_url         <- map["archive_url"]
        assignees_url       <- map["assignees_url"]
        blobs_url           <- map["blobs_url"]
        branches_url        <- map["branches_url"]
        clone_url           <- map["clone_url"]
        collaborators_url   <- map["collaborators_url"]
        comments_url        <- map["comments_url"]
        commits_url         <- map["commits_url"]
        compare_url         <- map["compare_url"]
        contents_url        <- map["contents_url"]
        contributors_url    <- map["contributors_url"]
        deployments_url     <- map["deployments_url"]
        downloads_url       <- map["downloads_url"]
        events_url          <- map["events_url"]
        forks_url           <- map["forks_url"]
        git_commits_url     <- map["git_commits_url"]
        git_refs_url        <- map["git_refs_url"]
        git_tags_url        <- map["git_tags_url"]
        git_url             <- map["git_url"]
        hooks_url           <- map["hooks_url"]
        issue_comment_url   <- map["issue_comment_url"]
        issue_events_url    <- map["issue_events_url"]
        issues_url          <- map["issues_url"]
        keys_url            <- map["keys_url"]
        labels_url          <- map["labels_url"]
        languages_url       <- map["languages_url"]
        merges_url          <- map["merges_url"]
        milestones_url      <- map["milestones_url"]
        mirror_url          <- map["mirror_url"]
        notifications_url   <- map["notifications_url"]
        pulls_url           <- map["pulls_url"]
        releases_url        <- map["releases_url"]
        ssh_url             <- map["ssh_url"]
        stargazers_url      <- map["stargazers_url"]
        statuses_url        <- map["statuses_url"]
        subscribers_url     <- map["subscribers_url"]
        subscription_url    <- map["subscription_url"]
        svn_url             <- map["svn_url"]
        tags_url            <- map["tags_url"]
        teams_url           <- map["teams_url"]
        trees_url           <- map["trees_url"]
        homepage            <- map["homepage"]
        language            <- map["language"]
        forks_count         <- map["forks_count"]
        stargazers_count    <- map["stargazers_count"]
        watchers_count      <- map["watchers_count"]
        size                <- map["size"]
        default_branch      <- map["default_branch"]
        open_issues_count   <- map["open_issues_count"]
        has_issues          <- map["has_issues"]
        has_wiki            <- map["has_wiki"]
        has_pages           <- map["has_pages"]
        has_downloads       <- map["has_downloads"]
        pushed_at           <- (map["pushed_at"], ISO8601DateTransform())
        created_at          <- (map["created_at"], ISO8601DateTransform())
        updated_at          <- (map["updated_at"], ISO8601DateTransform())
    }

}