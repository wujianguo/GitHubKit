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
    let rootEndpoint: RootEndpoint

    init() {
        let file = NSBundle(forClass: Manager.self).pathForResource("RootEndpoint", ofType: "json")!
        let data = NSData(contentsOfFile: file)!
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
            rootEndpoint = Mapper<RootEndpoint>(context: nil).map(json)!
        } catch {
            rootEndpoint = Mapper<RootEndpoint>(context: nil).map([])!
        }
    }
}


public protocol ResourceCacheInfo: Mappable {
    func setEtag(eTag: String)
    func setLastModified(lastModified: NSDate)
}


public class GitHubObject: ResourceCacheInfo {

    public var eTag: String?
    public var lastModified: NSDate?

    public func setEtag(eTag: String) {
        self.eTag = eTag;
    }

    public func setLastModified(lastModified: NSDate) {
        self.lastModified = lastModified
    }

    required public init?(_ map: Map) {

    }

    public func mapping(map: Map) {

    }
}


extension URITemplate {
    func expandOptional(variables:[String: AnyObject?]) -> String {
        var data = variables
        for (key, value) in data {
            if value == nil {
                data.removeValueForKey(key)
            }
        }
        debugPrint(expand(data as! [String: AnyObject]))
        return expand(data as! [String: AnyObject])
    }
}

public class ModifiableObject: GitHubObject {
    public var created_at: NSDate?
    public var updated_at: NSDate?

    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        created_at      <- (map["created_at"], ISO8601DateTransform())
        updated_at      <- (map["updated_at"], ISO8601DateTransform())
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

