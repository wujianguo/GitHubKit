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

public class Gist: GitHubObject {
    
    public var url: String?
    public var forks_url: String?
    public var commits_url: String?
    public var id: String?
    public var description: String?
    public var `public`: Bool?
    public var truncated: Bool?
    public var comments: Int?
    public var comments_url: String?
    public var html_url: String?
    public var git_pull_url: String?
    public var git_push_url: String?
    public var forks: [Fork]?
    public var history: [History]?
    public var created_at: NSDate?
    public var updated_at: NSDate?
    public var user: User?
    public var organization: Organization?
    
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
        truncated       <- map["truncated"]
        comments        <- map["comments"]
        comments_url    <- map["comments_url"]
        html_url        <- map["html_url"]
        git_pull_url    <- map["git_pull_url"]
        git_push_url    <- map["git_push_url"]
        forks           <- map["forks"]
        history         <- map["history"]
        created_at      <- (map["created_at"], ISO8601DateTransform())
        updated_at      <- (map["updated_at"], ISO8601DateTransform())

        if let owner = map.JSONDictionary["owner"] as? [String: AnyObject] {
            if let type = owner["type"] as? String {
                if type == "user" {
                    user <- map["owner"]
                } else if type == "Organization" {
                    organization <- map["owner"]
                }
            }
        }

    }
}

extension RootEndpoint {
    
    func gistRequest(gist_id: String? = nil) -> AuthorizationRequest {
        let uri = URITemplate(template: gists_url!)
        return AuthorizationRequest(url: uri.expandOptional(["gist_id": gist_id]))
    }
    
    func publicGistRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: public_gists_url!)
    }
    
    func starredGistsRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: starred_gists_url!)
    }
}

public func gistRequest(gist_id: String? = nil) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.gistRequest(gist_id)
}

public func publicGistRequest() -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.publicGistRequest()
}

public func starredGistsRequest() -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.starredGistsRequest()
}
