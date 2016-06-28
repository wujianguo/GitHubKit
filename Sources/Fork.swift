//
//  Fork.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import Alamofire
import ObjectMapper

public struct Fork: Mappable {
    
    public var user: User?
    public var url: String?
    public var id: String?
    public var created_at: NSDate?
    public var updated_at: NSDate?
    
    public init?(_ map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        user        <- map["user"]
        url         <- map["url"]
        id          <- map["id"]
        created_at  <- map["created_at"]
        updated_at  <- map["updated_at"]
    }
}