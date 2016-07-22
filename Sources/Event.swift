//
//  Event.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/22.
//
//

import Foundation
import Alamofire
import ObjectMapper

public enum EventType: CustomStringConvertible {
    case CommitComment
    case Create
    case Delete
    case Deployment
    case DeploymentStatus
    case Download
    case Follow
    case Fork
    case ForkApply
    case Gist
    case Gollum
    case IssueComment
    case Issues
    case Member
    case Membership
    case PageBuild
    case Public
    case PullRequest
    case PullRequestReviewComment
    case Push
    case Release
    case Repository
    case Status
    case TeamAdd
    case Watch

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
    public var create_at: NSDate?
    public var actor: User?
    public var org: Organization?

    required public init?(_ map: Map) {
        super.init(map)
    }

    public override func mapping(map: Map) {
        super.mapping(map)
        id          <- map["id"]
        type        <- map["type"]
        `public`    <- map["public"]
        create_at   <- (map["create_at"], ISO8601DateTransform())
        actor       <- map["actor"]
        org         <- map["org"]
    }
}

extension RootEndpoint {

    func eventRequest() -> Request {
        return Alamofire.request(.GET, events_url!)
    }
}

public func eventRequest() -> Request {
    return Manager.sharedInstance.rootEndpoint.eventRequest()
}