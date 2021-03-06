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

public let GitHubAuthorizationNotificationName = "GitHubAuthorizationNotificationName"
public let GitHubCurrentUserInfoNotificationName = "GitHubCurrentUserInfoNotificationName"

public func login() {
    if GitHubAuthorization.sharedInstance.access_token == nil {
        GitHubAuthorization.sharedInstance.authorize()
    }
}

public var currentUser: User?

public class GitHubAuthorization {

    static let sharedInstance = GitHubAuthorization()
    public class func config(access_token: String?, token_type: String? = "bearer", performAuthorizationRequire: ((completion: AuthorizationCompletion) -> Void)) {
        if let type = token_type {
            sharedInstance.token_type = type
        }
        if let token = access_token {
            sharedInstance.access_token = token
        }
        sharedInstance.performAuthorizationRequire = performAuthorizationRequire
    }

    private init() {

    }

    let queue = dispatch_queue_create("GitHubAuthorization", DISPATCH_QUEUE_SERIAL)
    var access_token: String? {
        didSet {
            updateCurrentUser()
        }
    }
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
                    if let t = type {
                        self.token_type = t
                    }
                    self.access_token = token
                    self.authorizing = false
                    NSNotificationCenter.defaultCenter().postNotificationName(GitHubAuthorizationNotificationName, object: nil, userInfo: nil)
                }
            }
        }
    }

    func updateCurrentUser() {
        guard access_token != nil else {
            currentUser = nil
            return
        }
        currentUserRequest().responseObject { (response: Response<User, NSError>) in
            currentUser = response.result.value
            NSNotificationCenter.defaultCenter().postNotificationName(GitHubCurrentUserInfoNotificationName, object: nil, userInfo: nil)
        }
    }
}

public class AuthorizationRequest {

    public let url: String
    let eTag: String?
    let lastModified: NSDate?
    let loginRequired: Bool
    var additionalHeaders: [String: String] = [:]
    var method: Alamofire.Method = .GET

    public init(url: String, eTag: String? = nil, lastModified: NSDate? = nil, loginRequired: Bool = false, method: Alamofire.Method = .GET, additionalHeaders: [String: String] = [:]) {
        self.url = url
        self.eTag = eTag
        self.lastModified = lastModified
        self.loginRequired = loginRequired
        self.additionalHeaders = additionalHeaders
        self.method = method
    }

    var cancelled: Bool = false
    var req: Request?
    public func cancel() {
        cancelled = true
        req?.cancel()
    }

    public func responseObject<T: GitHubObject>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: Response<T, NSError> -> Void) {
        let completionBlock: Response<T, NSError> -> Void = { (response) in
            if response.result.isSuccess, let ret = response.result.value {
                if let e = ret.eTag {
                    if self.eTag == e {
                        self.responseFailure(queue, failureReason: "Not Modified", code: 304, completionHandler: completionHandler)
                        return
                    }
                }
                if let d = ret.lastModified {
                    if self.lastModified == d {
                        self.responseFailure(queue, failureReason: "Not Modified", code: 304, completionHandler: completionHandler)
                        return
                    }
                }
                completionHandler(response)
            }
        }
        if loginRequired && !GitHubAuthorization.sharedInstance.validAuthorized {
            dispatch_async(GitHubAuthorization.sharedInstance.queue) {
                if !GitHubAuthorization.sharedInstance.validAuthorized {
                    NSNotificationCenter.defaultCenter().addObserverForName(GitHubAuthorizationNotificationName, object: nil, queue: nil) { (notification) in
                        NSNotificationCenter.defaultCenter().removeObserver(self, name: GitHubAuthorizationNotificationName, object: nil)
                        if self.cancelled {
                            self.responseFailure(queue, failureReason: "RequestCancelled", code: AuthorizationRequest.Code.RequestCancelled.rawValue, completionHandler: completionHandler)
                            return
                        }
                        if !GitHubAuthorization.sharedInstance.validAuthorized {
                            self.responseFailure(queue, failureReason: "RequestMissingAccessToken", code: AuthorizationRequest.Code.RequestMissingAccessToken.rawValue, completionHandler: completionHandler)
                            return
                        }
                        self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                        self.req?.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: completionBlock)
                    }
                    GitHubAuthorization.sharedInstance.authorize()
                } else {
                    self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                    self.req?.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: completionBlock)
                }
            }
            return
        }
        req = request(url, eTag: eTag, lastModified: lastModified)
        req?.responseObject(queue: queue, keyPath: keyPath, mapToObject: object, context: context, completionHandler: completionBlock)
    }

    public func responseArray<T: Mappable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: Response<GitHubArray<T>, NSError> -> Void) {
        let completionBlock: Response<GitHubArray<T>, NSError> -> Void = { (response) in
            if response.result.isSuccess, let ret = response.result.value {
                if let e = ret.eTag {
                    if self.eTag == e {
                        self.responseFailure(queue, failureReason: "Not Modified", code: 304, completionHandler: completionHandler)
                        return
                    }
                }
                if let d = ret.lastModified {
                    if self.lastModified == d {
                        self.responseFailure(queue, failureReason: "Not Modified", code: 304, completionHandler: completionHandler)
                        return
                    }
                }
                completionHandler(response)
            }
        }
        if loginRequired && !GitHubAuthorization.sharedInstance.validAuthorized {
            dispatch_async(GitHubAuthorization.sharedInstance.queue) {
                if !GitHubAuthorization.sharedInstance.validAuthorized {
                    NSNotificationCenter.defaultCenter().addObserverForName(GitHubAuthorizationNotificationName, object: nil, queue: nil) { (notification) in
                        NSNotificationCenter.defaultCenter().removeObserver(self, name: GitHubAuthorizationNotificationName, object: nil)
                        if self.cancelled {
                            self.responseFailure(queue, failureReason: "RequestCancelled", code: AuthorizationRequest.Code.RequestCancelled.rawValue, completionHandler: completionHandler)
                            return
                        }
                        if !GitHubAuthorization.sharedInstance.validAuthorized {
                            self.responseFailure(queue, failureReason: "RequestMissingAccessToken", code: AuthorizationRequest.Code.RequestMissingAccessToken.rawValue, completionHandler: completionHandler)
                            return
                        }
                        self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                        self.req?.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: completionBlock)
                    }
                    GitHubAuthorization.sharedInstance.authorize()
                } else {
                    self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                    self.req?.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: completionBlock)
                }
            }
            return
        }
        req = request(url, eTag: eTag, lastModified: lastModified)
        req?.responseArray(queue: queue, keyPath: keyPath, context: context, completionHandler: completionBlock)
    }

    public func responseBoolen(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, completionHandler: Response<Bool, NSError> -> Void) {
        let completionBlock: ((NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void) = { (request, response, data, error) in
            if let status = response?.statusCode {
                if status == 204 || status == 404 {
                    let result = Result<Bool, NSError>.Success(status == 204)
                    let response = Response(
                        request: request,
                        response: response,
                        data: data,
                        result: result
                    )
                    completionHandler(response)
                    return
                }
                let failureReason = NSHTTPURLResponse.localizedStringForStatusCode(status)
                self.responseFailure(queue, failureReason: failureReason, code: status, completionHandler: completionHandler)
                return
            }
            self.responseFailureError(queue, error: error!, completionHandler: completionHandler)
        }

        if loginRequired && !GitHubAuthorization.sharedInstance.validAuthorized {
            dispatch_async(GitHubAuthorization.sharedInstance.queue) {
                if !GitHubAuthorization.sharedInstance.validAuthorized {
                    NSNotificationCenter.defaultCenter().addObserverForName(GitHubAuthorizationNotificationName, object: nil, queue: nil) { (notification) in
                        NSNotificationCenter.defaultCenter().removeObserver(self, name: GitHubAuthorizationNotificationName, object: nil)
                        if self.cancelled {
                            self.responseFailure(queue, failureReason: "RequestCancelled", code: AuthorizationRequest.Code.RequestCancelled.rawValue, completionHandler: completionHandler)
                            return
                        }
                        if !GitHubAuthorization.sharedInstance.validAuthorized {
                            self.responseFailure(queue, failureReason: "RequestMissingAccessToken", code: AuthorizationRequest.Code.RequestMissingAccessToken.rawValue, completionHandler: completionHandler)
                            return
                        }
                        self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                        self.req?.response(queue: queue, completionHandler: completionBlock)
                    }
                    GitHubAuthorization.sharedInstance.authorize()
                } else {
                    self.req = self.request(self.url, eTag: self.eTag, lastModified: self.lastModified)
                    self.req?.response(queue: queue, completionHandler: completionBlock)
                }
            }
            return
        }
        req = request(url, eTag: eTag, lastModified: lastModified)
        req?.response(queue: queue, completionHandler: completionBlock)
    }

    public static let Domain = "com.githubkit.error"

    public enum Code: Int {
        case RequestCancelled           = -7000
        case RequestMissingAccessToken  = -7001
    }

    func responseFailure<T> (queue: dispatch_queue_t? = nil, failureReason: String, code: Int, completionHandler: Response<T, NSError> -> Void) {
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let error = NSError(domain: Error.Domain, code: code, userInfo: userInfo)
        let result = Result<T, NSError>.Failure(error)
        let response = Response(
            request: req?.request,
            response: nil,
            data: nil,
            result: result
        )
        if let q = queue {
            dispatch_async(q) {
                completionHandler(response)
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(response)
            }
        }
    }

    func responseFailureError<T> (queue: dispatch_queue_t? = nil, error: NSError, completionHandler: Response<T, NSError> -> Void) {
        let result = Result<T, NSError>.Failure(error)
        let response = Response(
            request: req?.request,
            response: nil,
            data: nil,
            result: result
        )
        if let q = queue {
            dispatch_async(q) {
                completionHandler(response)
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(response)
            }
        }
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
        for header in additionalHeaders {
            headers[header.0] = header.1
        }
        if headers.count > 0 {
            return Alamofire.request(method, url, headers: headers)
        } else {
            return Alamofire.request(method, url)
        }
    }
}