//
//  AuthorizationRequest.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/26.
//
//

import Foundation
import Alamofire
import ObjectMapper

public typealias AuthorizationCompletion = (access_token: String?, token_type: String?) -> Void

let GitHubAuthorizationNotificationName = "GitHubAuthorizationNotificationName"

public class GitHubAuthorization {

    static let sharedInstance = GitHubAuthorization()
    public class func config(access_token: String?, token_type: String? = "bearer", performAuthorizationRequire: ((completion: AuthorizationCompletion) -> Void)) {
        if let token = access_token {
            sharedInstance.access_token = token
        }
        if let type = token_type {
            sharedInstance.token_type = type
        }
        sharedInstance.performAuthorizationRequire = performAuthorizationRequire
    }

    init() {

    }

    let queue = dispatch_queue_create("GitHubAuthorization", DISPATCH_QUEUE_SERIAL)
    var access_token: String?
    var token_type = "bearer"
    var performAuthorizationRequire: ((completion: AuthorizationCompletion) -> Void)?

    var authorizing: Bool = false

    var validAuthorized: Bool {
        return access_token != nil
    }

    func authorize() {
        dispatch_async(queue) {
            guard !self.validAuthorized && !self.authorizing else { return }
            self.authorizing = true
            self.performAuthorizationRequire? { (token, type) in
                dispatch_async(self.queue) {
                    self.access_token = token
                    if let t = type {
                        self.token_type = t
                    }
                    self.authorizing = false
                    NSNotificationCenter.defaultCenter().postNotificationName(GitHubAuthorizationNotificationName, object: nil, userInfo: nil)
                }
            }
        }
    }
}

public class AuthorizationRequest {

    public let url: String
    let eTag: String?
    let lastModified: NSDate?
    let loginRequired: Bool

    public init(url: String, eTag: String? = nil, lastModified: NSDate? = nil, loginRequired: Bool = false) {
        self.url = url
        self.eTag = eTag
        self.lastModified = lastModified
        self.loginRequired = loginRequired
    }

    var cancelled: Bool = false
    var req: Request?
    public func cancel() {
        cancelled = true
        req?.cancel()
    }

    public func responseObject<T: GitHubObject>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: Response<T, NSError> -> Void) {
        if loginRequired && !GitHubAuthorization.sharedInstance.validAuthorized {
            dispatch_async(GitHubAuthorization.sharedInstance.queue) {
                if !GitHubAuthorization.sharedInstance.validAuthorized {
                    NSNotificationCenter.defaultCenter().addObserverForName(GitHubAuthorizationNotificationName, object: self, queue: nil) { (notification) in
                        guard !self.cancelled else { return }
                        // todo: token == nil still
                        self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                        self.req?.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: completionHandler)
                    }
                    GitHubAuthorization.sharedInstance.authorize()
                } else {
                    self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                    self.req?.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: completionHandler)
                }
            }
            return
        }
        req = request(url, eTag: eTag, lastModified: lastModified)
        req?.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: completionHandler)
    }

    public func responseArray<T: Mappable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: Response<GitHubArray<T>, NSError> -> Void) {
        if loginRequired && !GitHubAuthorization.sharedInstance.validAuthorized {
            dispatch_async(GitHubAuthorization.sharedInstance.queue) {
                if !GitHubAuthorization.sharedInstance.validAuthorized {
                    NSNotificationCenter.defaultCenter().addObserverForName(GitHubAuthorizationNotificationName, object: self, queue: nil) { (notification) in
                        guard !self.cancelled else { return }
                        // todo: token == nil still
                        self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                        self.req?.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: completionHandler)
                    }
                    GitHubAuthorization.sharedInstance.authorize()
                } else {
                    self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                    self.req?.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: completionHandler)
                }
            }
            return
        }
        req = request(url, eTag: eTag, lastModified: lastModified)
        req?.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: completionHandler)
    }

    func request(url: String, eTag: String? = nil, lastModified: NSDate? = nil) -> Request {
        var headers = [String: String]()
        if let token = GitHubAuthorization.sharedInstance.access_token {
            headers["Authorization"] = "token \(token)"
        }
        if let e = eTag {
            headers["If-None-Match"] = e
        } else if let d = lastModified {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, dd LLL yyyy hh:mm:ss zzz"
            headers["If-Modified-Since"] = dateFormatter.stringFromDate(d)
        }
        if headers.count > 0 {
            return Alamofire.request(.GET, url, headers: headers)
        } else {
            return Alamofire.request(.GET, url)
        }
    }
}