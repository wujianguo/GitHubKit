//
//  User.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import ObjectMapper

public class User: GitHubObject {
    
    public var login: String?
    public var id: Int?
    public var avatar_url: String?
    public var gravatar_id: String?
    public var url: String?
    public var html_url: String?
    public var followers_url: String?
    public var following_url: String?
    public var gists_url: String?
    public var starred_url: String?
    public var subscriptions_url: String?
    public var organizations_url: String?
    public var repos_url: String?
    public var events_url: String?
    public var received_events_url: String?
    public var type: String?
    public var site_admin: Bool?
    
    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        login               <- map["login"]
        id                  <- map["id"]
        avatar_url          <- map["avatar_url"]
        gravatar_id         <- map["gravatar_id"]
        url                 <- map["url"]
        html_url            <- map["html_url"]
        followers_url       <- map["followers_url"]
        following_url       <- map["following_url"]
        gists_url           <- map["gists_url"]
        starred_url         <- map["starred_url"]
        subscriptions_url   <- map["subscriptions_url"]
        organizations_url   <- map["organizations_url"]
        repos_url           <- map["repos_url"]
        events_url          <- map["events_url"]
        received_events_url <- map["received_events_url"]
        type                <- map["type"]
        site_admin          <- map["site_admin"]
    }
}