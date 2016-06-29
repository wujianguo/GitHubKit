//
//  Fork.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import ObjectMapper

public class Fork: ModifiableObject {
    
    public var user: User?
    public var url: String?
    public var id: String?

    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        user        <- map["user"]
        url         <- map["url"]
        id          <- map["id"]
    }
}