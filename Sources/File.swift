//
//  File.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import ObjectMapper

public class File: GitHubObject {
    
    public var filename: String?
    public var type: String?
    public var language: String?
    public var raw_url: String?
    public var size: Int?
    
    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        filename    <- map["filename"]
        type        <- map["type"]
        language    <- map["language"]
        raw_url     <- map["raw_url"]
        size        <- map["size"]
    }
}