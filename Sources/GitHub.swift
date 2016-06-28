//
//  GitHub.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import Alamofire
import ObjectMapper


let baseURL = "https://api.github.com"

public struct RootEndpoint: Mappable {

    public var current_user_url = "https://api.github.com/user"
    public var current_user_authorizations_html_url = "https://github.com/settings/connections/applications{/client_id}"
    public var authorizations_url = "https://api.github.com/authorizations"
    public var code_search_url = "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}"
    public var emails_url = "https://api.github.com/user/emails"
    public var emojis_url = "https://api.github.com/emojis"
    public var events_url = "https://api.github.com/events"
    public var feeds_url = "https://api.github.com/feeds"
    public var followers_url = "https://api.github.com/user/followers"
    public var following_url = "https://api.github.com/user/following{/target}"
    public var gists_url = "https://api.github.com/gists{/gist_id}"
    public var hub_url = "https://api.github.com/hub"
    public var issue_search_url = "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}"
    public var issues_url = "https://api.github.com/issues"
    public var keys_url = "https://api.github.com/user/keys"
    public var notifications_url = "https://api.github.com/notifications"
    public var organization_repositories_url = "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}"
    public var organization_url = "https://api.github.com/orgs/{org}"
    public var public_gists_url = "https://api.github.com/gists/public"
    public var rate_limit_url = "https://api.github.com/rate_limit"
    public var repository_url = "https://api.github.com/repos/{owner}/{repo}"
    public var repository_search_url = "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}"
    public var current_user_repositories_url = "https://api.github.com/user/repos{?type,page,per_page,sort}"
    public var starred_url = "https://api.github.com/user/starred{/owner}{/repo}"
    public var starred_gists_url = "https://api.github.com/gists/starred"
    public var team_url = "https://api.github.com/teams"
    public var user_url = "https://api.github.com/users/{user}"
    public var user_organizations_url = "https://api.github.com/user/orgs"
    public var user_repositories_url = "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}"
    public var user_search_url = "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}"

    public init?(_ map: Map) {

    }

    mutating public func mapping(map: Map) {
        current_user_url                        <- map["current_user_url"]
        current_user_authorizations_html_url    <- map["current_user_authorizations_html_url"]
        authorizations_url                      <- map["authorizations_url"]
        code_search_url                         <- map["code_search_url"]
        emails_url                              <- map["emails_url"]
        emojis_url                              <- map["emojis_url"]
        events_url                              <- map["events_url"]
        feeds_url                               <- map["feeds_url"]
        followers_url                           <- map["followers_url"]
        following_url                           <- map["following_url"]
        gists_url                               <- map["gists_url"]
        hub_url                                 <- map["hub_url"]
        issue_search_url                        <- map["issue_search_url"]
        issues_url                              <- map["issues_url"]
        keys_url                                <- map["keys_url"]
        notifications_url                       <- map["notifications_url"]
        organization_repositories_url           <- map["organization_repositories_url"]
        organization_url                        <- map["organization_url"]
        public_gists_url                        <- map["public_gists_url"]
        rate_limit_url                          <- map["rate_limit_url"]
        repository_url                          <- map["repository_url"]
        repository_search_url                   <- map["repository_search_url"]
        current_user_repositories_url           <- map["current_user_repositories_url"]
        starred_url                             <- map["starred_url"]
        starred_gists_url                       <- map["starred_gists_url"]
        team_url                                <- map["team_url"]
        user_url                                <- map["user_url"]
        user_organizations_url                  <- map["user_organizations_url"]
        user_repositories_url                   <- map["user_repositories_url"]
        user_search_url                         <- map["user_search_url"]
        
    }
}


public func rootEndpointRequest() -> Request {
    return Alamofire.request(.GET, baseURL)
}
