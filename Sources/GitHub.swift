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


struct RootEndpoint: Mappable {

    var current_user_url = "https://api.github.com/user"
    /*
    var current_user_authorizations_html_url = "https://github.com/settings/connections/applications{/client_id}"
    var authorizations_url = "https://api.github.com/authorizations"
    var code_search_url = "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}"
    var emails_url = "https://api.github.com/user/emails"
    var emojis_url = "https://api.github.com/emojis"
    var events_url = "https://api.github.com/events"
    var feeds_url = "https://api.github.com/feeds"
    var followers_url = "https://api.github.com/user/followers"
    var following_url = "https://api.github.com/user/following{/target}"
    var gists_url = "https://api.github.com/gists{/gist_id}"
    var hub_url = "https://api.github.com/hub"
    var issue_search_url = "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}"
    var issues_url = "https://api.github.com/issues"
    var keys_url = "https://api.github.com/user/keys"
    var notifications_url = "https://api.github.com/notifications"
    var organization_repositories_url = "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}"
    var organization_url = "https://api.github.com/orgs/{org}"
    var public_gists_url = "https://api.github.com/gists/public"
    var rate_limit_url = "https://api.github.com/rate_limit"
    var repository_url = "https://api.github.com/repos/{owner}/{repo}"
    var repository_search_url = "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}"
    var current_user_repositories_url = "https://api.github.com/user/repos{?type,page,per_page,sort}"
    var starred_url = "https://api.github.com/user/starred{/owner}{/repo}"
    var starred_gists_url = "https://api.github.com/gists/starred"
    var team_url = "https://api.github.com/teams"
    var user_url = "https://api.github.com/users/{user}"
    var user_organizations_url = "https://api.github.com/user/orgs"
    var user_repositories_url = "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}"
    var user_search_url = "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}"

    */
    init?(_ map: Map) {

    }

    mutating func mapping(map: Map) {
        current_user_url                        <- map["current_user_url"]
        /*
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
        */
    }
}


public func rootEndpointRequest() -> Request {
    return Alamofire.request(.GET, baseURL)
}

public func t() {
    rootEndpointRequest().responseObject { (response: Response<RootEndpoint, NSError>) in
        print(response.result.value?.currentUserUrl)
    }
}