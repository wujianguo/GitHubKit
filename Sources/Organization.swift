//
//  Organization.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/22.
//
//

import Foundation
import Alamofire
import ObjectMapper

public class Organization: GitHubObject {

    public var login: String?
    public var id: Int?
    public var avatar_url: String?
    public var url: String?
    public var repos_url: String?
    public var members_url: String?
    public var events_url: String?
    public var hooks_url: String?
    public var issues_url: String?
    public var public_members_url: String?
    public var description: String?

    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        login               <- map["login"]
        id                  <- map["id"]
        avatar_url          <- map["avatar_url"]
        url                 <- map["url"]
        repos_url           <- map["repos_url"]
        members_url         <- map["members_url"]
        events_url          <- map["events_url"]
        hooks_url           <- map["hooks_url"]
        issues_url          <- map["issues_url"]
        public_members_url  <- map["public_members_url"]
        description         <- map["description"]
    }
}