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

public class Organization: Profile {

    public var members_url: String?
    public var hooks_url: String?
    public var issues_url: String?
    public var public_members_url: String?
    public var description: String?

    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        members_url         <- map["members_url"]
        hooks_url           <- map["hooks_url"]
        issues_url          <- map["issues_url"]
        public_members_url  <- map["public_members_url"]
        description         <- map["description"]
    }
}