//
//  Gist.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import Alamofire
import ObjectMapper

public struct Gist: Mappable {
    
    public var url: String?
    public var forks_url: String?
    public var commits_url: String?
    public var id: String?
    public var description: String?
    public var `public`: Bool?
    public var owner: User?
    public var truncated: Bool?
    public var comments: Int?
    public var comments_url: String?
    public var html_url: String?
    public var git_pull_url: String?
    public var git_push_url: String?
    public var created_at: NSDate?
    public var updated_at: NSDate?
    public var forks: [Fork]?
    public var history: [History]?
    
    public init?(_ map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        url             <- map["url"]
        forks_url       <- map["forks_url"]
        commits_url     <- map["commits_url"]
        id              <- map["id"]
        description     <- map["description"]
        `public`        <- map["public"]
        owner           <- map["owner"]
        truncated       <- map["truncated"]
        comments        <- map["comments"]
        comments_url    <- map["comments_url"]
        html_url        <- map["html_url"]
        git_pull_url    <- map["git_pull_url"]
        git_push_url    <- map["git_push_url"]
        created_at      <- map["created_at"]
        updated_at      <- map["updated_at"]
        forks           <- map["forks"]
        history         <- map["history"]
    }
}