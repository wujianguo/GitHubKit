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

public class Gist: ModifiableObject {
    
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
    public var forks: [Fork]?
    public var history: [History]?
    
    required public init?(_ map: Map) {
        super.init(map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map)
        url             <- map["url"]
        forks_url       <- map["forks_url"]
        commits_url     <- map["commits_url"]
        id              <- map["id"]
        description     <- map["description"]
        `public`        <- map["public"]
        owner           <- map["owner"]
//        owner           <- (map["owner"], TransformOf<User, String>(fromJSON: { Mapper<User>().map($0) }, toJSON: { Mapper().toJSONString($0) }))
        truncated       <- map["truncated"]
        comments        <- map["comments"]
        comments_url    <- map["comments_url"]
        html_url        <- map["html_url"]
        git_pull_url    <- map["git_pull_url"]
        git_push_url    <- map["git_push_url"]
        forks           <- map["forks"]
        history         <- map["history"]
    }
}

extension RootEndpoint {
    func gistRequest(gist_id: String? = nil) -> Request {
        let uri = URITemplate(template: gists_url!)
        return Alamofire.request(.GET, uri.expandOptional(["gist_id": gist_id]))
    }
}

public func gistRequest(gist_id: String? = nil) -> Request {
    return Manager.sharedInstance.rootEndpoint.gistRequest(gist_id)
}
