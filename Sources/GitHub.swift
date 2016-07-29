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

class Manager {

    static let sharedInstance = Manager()
    var rootEndpoint: RootEndpoint

    private init() {
        let file = NSBundle(forClass: Manager.self).pathForResource("RootEndpoint", ofType: "json")!
        let data = NSData(contentsOfFile: file)!
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
            rootEndpoint = Mapper<RootEndpoint>(context: nil).map(json)!
        } catch {
            rootEndpoint = Mapper<RootEndpoint>(context: nil).map([])!
        }
        /*
        let url = "https://api.github.com/"
        let req = AuthorizationRequest(url: url, eTag: "\"d251d84fc3f78921c16c7f9c99d74eae\"")
        req.responseObject { (response: Response<RootEndpoint, NSError>) in
            if response.result.isSuccess, let ret = response.result.value {
                self.rootEndpoint = ret
            }
        }
        */
    }
}

public protocol RFC5988 {
    var eTag: String? { get set }
    var lastModified:  NSDate? { get set }
}

public protocol RFC6570 {
    var prePageLink: String? { get set }
    var nextPageLink: String? { get set }
    var firstPageLink: String? { get set }
    var lastPageLink: String? { get set }
}

public class GitHubArrayInfo: RFC5988, RFC6570 {
    
    public var eTag: String?
    public var lastModified: NSDate?
    public var prePageLink: String?
    public var nextPageLink: String?
    public var firstPageLink: String?
    public var lastPageLink: String?
}

public class GitHubObject: RFC5988, Mappable {
    
    public var eTag: String?
    public var lastModified: NSDate?

    required public init?(_ map: Map) {

    }

    public func mapping(map: Map) {

    }
}

public class GitHubArray<T: Mappable>: GitHubArrayInfo {
    public var array = [T]()    
}


extension URITemplate {
    func expandOptional(variables:[String: AnyObject?]) -> String {
        var data = variables
        for (key, value) in data {
            if value == nil {
                data.removeValueForKey(key)
            }
        }
        debugPrint("expandOptional \(expand(data as! [String: AnyObject]))")
        return expand(data as! [String: AnyObject])
    }
}

public class RootEndpoint: GitHubObject {

    public var current_user_url: String?
    public var current_user_authorizations_html_url: String?
    public var authorizations_url: String?
    public var code_search_url: String?
    public var emails_url: String?
    public var emojis_url: String?
    public var events_url: String?
    public var feeds_url: String?
    public var followers_url: String?
    public var following_url: String?
    public var gists_url: String?
    public var hub_url: String?
    public var issue_search_url: String?
    public var issues_url: String?
    public var keys_url: String?
    public var notifications_url: String?
    public var organization_repositories_url: String?
    public var organization_url: String?
    public var public_gists_url: String?
    public var rate_limit_url: String?
    public var repository_url: String?
    public var repository_search_url: String?
    public var current_user_repositories_url: String?
    public var starred_url: String?
    public var starred_gists_url: String?
    public var team_url: String?
    public var user_url: String?
    public var user_organizations_url: String?
    public var user_repositories_url: String?
    public var user_search_url: String?

    public var public_repos_url: String? = "https://api.github.com/repositories"
    public var all_users_url: String? = "https://api.github.com/users"
    public var repository_events_url: String? {
        return "\(repository_url!)/events"
    }
    public var repository_issue_events_url: String? {
        return "\(repository_url!)/issues/events"
    }
    public var repository_events_for_network_url: String? = "https://api.github.com/networks/{owner}/{repo}/events"
    public var organization_public_events_url: String? {
        return "\(organization_url!)/events"
    }
    public var user_received_events_url: String? {
        return "\(user_url!)/received_events"
    }
    public var user_received_public_events_url: String? {
        return "\(user_url!)/received_events/public"
    }
    public var user_performed_events_url: String? {
        return "\(user_url!)/events"
    }
    public var user_performed_public_events_url: String? {
        return "\(user_url!)/events/public"
    }
    public var user_organization_events_url: String? {
        return "\(user_url!)/events/orgs/{org}"
    }
    public var stargazers_url: String? {
        return "\(repository_url!)/stargazers"
    }
    public var uesr_starred_repos_url: String? {
        return "\(user_url!)/starred"
    }

    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
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


public var rootEndpoint: RootEndpoint {
    return Manager.sharedInstance.rootEndpoint
}
