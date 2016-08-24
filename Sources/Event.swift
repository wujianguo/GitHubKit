//
//  Event.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/22.
//
//

import Foundation
import ObjectMapper

public enum EventType: String, CustomStringConvertible {
    case CommitComment              = "CommitCommentEvent"
    case Create                     = "CreateEvent"
    case Delete                     = "DeleteEvent"
    case Deployment                 = "DeploymentEvent"
    case DeploymentStatus           = "DeploymentStatusEvent"
    case Download                   = "DownloadEvent"
    case Follow                     = "FollowEvent"
    case Fork                       = "ForkEvent"
    case ForkApply                  = "ForkApplyEvent"
    case Gist                       = "GistEvent"
    case Gollum                     = "GollumEvent"
    case IssueComment               = "IssueCommentEvent"
    case Issues                     = "IssuesEvent"
    case Member                     = "MemberEvent"
    case Membership                 = "MembershipEvent"
    case PageBuild                  = "PageBuildEvent"
    case Public                     = "PublicEvent"
    case PullRequest                = "PullRequestEvent"
    case PullRequestReviewComment   = "PullRequestReviewCommentEvent"
    case Push                       = "PushEvent"
    case Release                    = "ReleaseEvent"
    case Repository                 = "RepositoryEvent"
    case Status                     = "StatusEvent"
    case TeamAdd                    = "TeamAddEvent"
    case Watch                      = "WatchEvent"

    public var description: String {
        switch self {
        case .CommitComment:
            return "CommitCommentEvent"
        case .Create:
            return "CreateEvent"
        case .Delete:
            return "DeleteEvent"
        case .Deployment:
            return "DeploymentEvent"
        case .DeploymentStatus:
            return "DeploymentStatusEvent"
        case .Download:
            return "DownloadEvent"
        case .Follow:
            return "FollowEvent"
        case .Fork:
            return "ForkEvent"
        case .ForkApply:
            return "ForkApplyEvent"
        case .Gist:
            return "GistEvent"
        case .Gollum:
            return "GollumEvent"
        case .IssueComment:
            return "IssueCommentEvent"
        case .Issues:
            return "IssuesEvent"
        case .Member:
            return "MemberEvent"
        case .Membership:
            return "MembershipEvent"
        case .PageBuild:
            return "PageBuildEvent"
        case .Public:
            return "PublicEvent"
        case .PullRequest:
            return "PullRequestEvent"
        case .PullRequestReviewComment:
            return "PullRequestReviewCommentEvent"
        case .Push:
            return "PushEvent"
        case .Release:
            return "ReleaseEvent"
        case .Repository:
            return "RepositoryEvent"
        case .Status:
            return "StatusEvent"
        case .TeamAdd:
            return "TeamAddEvent"
        case .Watch:
            return "WatchEvent"
        }
    }
}

public class Event: GitHubObject {

    public var id: String?
    public var type: EventType?
    public var `public`: Bool?
    public var created_at: NSDate?
    public var actor: User?
    public var org: Organization?
    public var repo: Repository?

    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        id          <- map["id"]
        type        <- map["type"]
        `public`    <- map["public"]
        created_at  <- (map["created_at"], ISO8601DateTransform())
        actor       <- map["actor"]
        org         <- map["org"]
        repo        <- map["repo"]
    }
}

extension RootEndpoint {

    func publicEventsRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: events_url!)
    }

    func repositoryEventsRequest(owner: String, repo: String) -> AuthorizationRequest {
        let uri = URITemplate(template: repository_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]))
    }

    func repositoryIssueEventsRequest(owner: String, repo: String) -> AuthorizationRequest {
        let uri = URITemplate(template: repository_issue_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]))
    }

    func repositoryPublicEventsForNetworkRequest(owner: String, repo: String) -> AuthorizationRequest {
        let uri = URITemplate(template: repository_events_for_network_url!)
        return AuthorizationRequest(url: uri.expandOptional(["owner": owner, "repo": repo]))
    }

    func organizationPublicEventsRequest(org: String) -> AuthorizationRequest {
        let uri = URITemplate(template: organization_public_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["org": org]))
    }

    func userReceivedEventsRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: user_received_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["user": user]))
    }

    func userReceivedPublicEventsRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: user_received_public_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["user": user]))
    }

    func userPerformedEventsRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: user_performed_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["user": user]))
    }

    func userPerformedPublicEventsRequest(user: String) -> AuthorizationRequest {
        let uri = URITemplate(template: user_performed_public_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["user": user]))
    }

    func userPerformedPublicEventsRequest(user: String, org: String) -> AuthorizationRequest {
        let uri = URITemplate(template: user_organization_events_url!)
        return AuthorizationRequest(url: uri.expandOptional(["user": user, "org": org]), loginRequired: true)
    }
}

// https://developer.github.com/v3/activity/events/#list-public-events
public func publicEventsRequest() -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.publicEventsRequest()
}

// https://developer.github.com/v3/activity/events/#list-repository-events
public func repositoryEventsRequest(owner: String, repo: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.repositoryEventsRequest(owner, repo: repo)
}

// https://developer.github.com/v3/activity/events/#list-issue-events-for-a-repository
// todo: Repository issue events have a different format than other events
public func repositoryIssueEventsRequest(owner: String, repo: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.repositoryIssueEventsRequest(owner, repo: repo)
}

// https://developer.github.com/v3/activity/events/#list-public-events-for-a-network-of-repositories
public func repositoryPublicEventsForNetworkRequest(owner: String, repo: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.repositoryPublicEventsForNetworkRequest(owner, repo: repo)
}

// https://developer.github.com/v3/activity/events/#list-public-events-for-an-organization
public func organizationPublicEventsRequest(org: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.organizationPublicEventsRequest(org)
}

// https://developer.github.com/v3/activity/events/#list-events-that-a-user-has-received
public func userReceivedEventsRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userReceivedEventsRequest(user)
}

// https://developer.github.com/v3/activity/events/#list-public-events-that-a-user-has-received
public func userReceivedPublicEventsRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userReceivedPublicEventsRequest(user)
}

// https://developer.github.com/v3/activity/events/#list-events-performed-by-a-user
public func userPerformedEventsRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userPerformedEventsRequest(user)
}

// https://developer.github.com/v3/activity/events/#list-public-events-performed-by-a-user
public func userPerformedPublicEventsRequest(user: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userPerformedPublicEventsRequest(user)
}

// https://developer.github.com/v3/activity/events/#list-events-for-an-organization
public func userPerformedPublicEventsRequest(user: String, org: String) -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.userPerformedPublicEventsRequest(user, org: org)
}
