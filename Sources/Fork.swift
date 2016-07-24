//
//  Fork.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import ObjectMapper

public class Fork: GitHubObject {
    
    public var user: User?
    public var url: String?
    public var id: String?
    public var created_at: NSDate?
    public var updated_at: NSDate?

    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        user        <- map["user"]
        url         <- map["url"]
        id          <- map["id"]
        created_at      <- (map["created_at"], ISO8601DateTransform())
        updated_at      <- (map["updated_at"], ISO8601DateTransform())
    }
}