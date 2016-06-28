//
//  History.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation

import Alamofire
import ObjectMapper

public struct ChangeStatus: Mappable {
    
    public var deletions: Int?
    public var additions: Int?
    public var total: Int?
    
    public init?(_ map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        deletions   <- map["deletions"]
        additions   <- map["additions"]
        total       <- map["total"]
    }
}

public struct History: Mappable {

    public var url: String?
    public var version: String?
    public var user: User?
    public var committed_at: NSDate?
    public var change_status: ChangeStatus?
    
    public init?(_ map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        url             <- map["url"]
        version         <- map["version"]
        user            <- map["user"]
        committed_at    <- map["committed_at"]
        change_status   <- map["change_status"]
    }
}