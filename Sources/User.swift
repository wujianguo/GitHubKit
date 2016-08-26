//
//  User.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import ObjectMapper

public class Profile: GitHubObject {

    public var login: String?
    public var id: Int?
    public var avatar_url: String?
    public var url: String?
    public var html_url: String?
    public var followers_url: String?
    public var following_url: String?
    public var repos_url: String?
    public var events_url: String?
    public var name: String?
    public var company: String?
    public var blog: String?
    public var location: String?
    public var email: String?
    public var public_repos: Int?
    public var public_gists: Int?
    public var created_at: NSDate?

    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        login               <- map["login"]
        id                  <- map["id"]
        avatar_url          <- map["avatar_url"]
        url                 <- map["url"]
        html_url            <- map["html_url"]
        followers_url       <- map["followers_url"]
        following_url       <- map["following_url"]
        repos_url           <- map["repos_url"]
        events_url          <- map["events_url"]
        name                <- map["name"]
        company             <- map["company"]
        blog                <- map["blog"]
        location            <- map["location"]
        email               <- map["email"]
        public_repos        <- map["public_repos"]
        public_gists        <- map["public_gists"]
        created_at          <- (map["created_at"], ISO8601DateTransform())
    }
}

public extension Profile {

    public func updateSelfRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: url!)
    }
}

public class User: Profile {
    
    public var gravatar_id: String?
    public var gists_url: String?
    public var starred_url: String?
    public var subscriptions_url: String?
    public var organizations_url: String?
    public var received_events_url: String?
    public var type: String?
    public var site_admin: Bool?
    public var hireable: Bool?
    public var bio: String?
    public var followers: Int?
    public var following: Int?
    public var updated_at: NSDate?
    
    public required init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        gravatar_id         <- map["gravatar_id"]
        gists_url           <- map["gists_url"]
        starred_url         <- map["starred_url"]
        subscriptions_url   <- map["subscriptions_url"]
        organizations_url   <- map["organizations_url"]
        received_events_url <- map["received_events_url"]
        type                <- map["type"]
        site_admin          <- map["site_admin"]
        bio                 <- map["bio"]
        followers           <- map["followers"]
        following           <- map["following"]
        updated_at          <- (map["updated_at"], ISO8601DateTransform())
    }
}


public extension User {

    public func followersRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: followers_url!)
    }

    public func followingRequest(other_user: String? = nil) -> AuthorizationRequest {
        let uri = URITemplate(template: following_url!)
        return AuthorizationRequest(url: uri.expandOptional(["other_user": other_user]))
    }

    public func starredRequest(owner: String? = nil, repo: String? = nil) -> AuthorizationRequest {
        let uri = URITemplate(template: starred_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]))
    }

}

extension RootEndpoint {

    func currentUserRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: current_user_url!, loginRequired: true)
    }

    func userRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: user_url!)
        return AuthorizationRequest(url: uri.expandOptional(["user": user]))
    }

    func allUsersRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: all_users_url!)
    }

    func checkfollowUserRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: following_url!)
        return AuthorizationRequest(url: uri.expand(["target": user]))
    }

    func followUserRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: following_url!)
        return AuthorizationRequest(url: uri.expand(["target": user]), method: .PUT)
    }

    func unfollowUserRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: following_url!)
        return AuthorizationRequest(url: uri.expand(["target": user]), method: .DELETE)
    }
}

public func currentUserRequest() -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.currentUserRequest()
}

public func userRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userRequest(user)
}

public func allUsersRequest() -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.allUsersRequest()
}

public func followUserRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.followUserRequest(user)
}

public func unfollowUserRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.unfollowUserRequest(user)
}

public func checkfollowUserRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.checkfollowUserRequest(user)
}
