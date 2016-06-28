//
//  File.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import Alamofire
import ObjectMapper

public struct File: Mappable {
    
    public var filename: String?
    public var type: String?
    public var language: String?
    public var raw_url: String?
    public var size: Int?
    
    public init?(_ map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        filename    <- map["filename"]
        type        <- map["type"]
        language    <- map["language"]
        raw_url     <- map["raw_url"]
        size        <- map["size"]
    }
}