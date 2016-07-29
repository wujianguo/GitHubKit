//
//  Starring.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/29.
//
//

import Foundation
import ObjectMapper
import Alamofire

public class StargazerUser: GitHubObject {

    public var starred_at: NSDate?
    public var user: User?

    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        starred_at  <- (map["starred_at"], ISO8601DateTransform())
        user        <- map["user"]
    }
}

public class StargazerRepo: GitHubObject {

    public var starred_at: NSDate?
    public var repo: Repository?

    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        starred_at  <- (map["starred_at"], ISO8601DateTransform())
        repo        <- map["repo"]
    }
}


extension RootEndpoint {

    func stargazersRequest(owner: String, repo: String, responseStarredTime: Bool) -> AuthorizationRequest {
        let uri = URITemplate(template: stargazers_url!)
        if responseStarredTime {
            return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]), additionalHeaders: ["Accept": "application/vnd.github.v3.star+json"])
        } else {
            return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]))
        }
    }

    func userStarredReposRequest(user: String, responseStarredTime: Bool) -> AuthorizationRequest {
        let uri = URITemplate(template: uesr_starred_repos_url!)
        if responseStarredTime {
            return AuthorizationRequest(url: uri.expandOptional(["user": user]), additionalHeaders: ["Accept": "application/vnd.github.v3.star+json"])
        } else {
            return AuthorizationRequest(url: uri.expandOptional(["user": user]))
        }
    }

    func starredReposRequest(responseStarredTime: Bool) -> AuthorizationRequest {
        let uri = URITemplate(template: starred_url!)
        if responseStarredTime {
            return AuthorizationRequest(url: uri.expandOptional([:]), loginRequired: true, additionalHeaders: ["Accept": "application/vnd.github.v3.star+json"])
        } else {
            return AuthorizationRequest(url: uri.expandOptional([:]), loginRequired: true)
        }
    }

    func checkStarringRepoRequest(owner: String, repo: String) -> AuthorizationRequest {
        let uri = URITemplate(template: starred_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]), loginRequired: true)
    }

    func starRepoRequest(owner: String, repo: String) -> AuthorizationRequest {
        let uri = URITemplate(template: starred_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]), loginRequired: true, method: .PUT)
    }

    func unstarRepoRequest(owner: String, repo: String) -> AuthorizationRequest {
        let uri = URITemplate(template: starred_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]), loginRequired: true, method: .DELETE)
    }
}

public func stargazersRequest(owner: String, repo: String, responseStarredTime: Bool) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.stargazersRequest(owner, repo: repo, responseStarredTime: responseStarredTime)
}

public func userStarredReposRequest(user: String, responseStarredTime: Bool) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userStarredReposRequest(user, responseStarredTime: responseStarredTime)
}

public func starredReposRequest(responseStarredTime: Bool) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.starredReposRequest(responseStarredTime)
}

public func checkStarringRepoRequest(owner: String, repo: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.checkStarringRepoRequest(owner, repo: repo)
}

public func starRepoRequest(owner: String, repo: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.starRepoRequest(owner, repo: repo)
}

public func unstarRepoRequest(owner: String, repo: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.unstarRepoRequest(owner, repo: repo)
}



