//
//  History.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import ObjectMapper

public class ChangeStatus: GitHubObject {
    
    public var deletions: Int?
    public var additions: Int?
    public var total: Int?
    
    public required init?(_ map: Map) {
        super.init(map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map)
        deletions   <- map["deletions"]
        additions   <- map["additions"]
        total       <- map["total"]
    }
}

public class History: GitHubObject {

    public var url: String?
    public var version: String?
    public var user: User?
    public var committed_at: NSDate?
    public var change_status: ChangeStatus?
    
    public required init?(_ map: Map) {
        super.init(map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map)
        url             <- map["url"]
        version         <- map["version"]
        user            <- map["user"]
        committed_at    <- map["committed_at"]
        change_status   <- map["change_status"]
    }
}