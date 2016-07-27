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

    func eventRequest() -> AuthorizationRequest {
        return AuthorizationRequest(url: events_url!)
    }
}

public func eventRequest() -> AuthorizationRequest {
    return Manager.sharedInstance.rootEndpoint.eventRequest()
}