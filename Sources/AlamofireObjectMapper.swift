//
//  AlamofireObjectMapper.swift
//  GitHubKit
//
//  Created by wujianguo on 16/6/28.
//
//

import Foundation
import Alamofire
import ObjectMapper


extension NSHTTPURLResponse {
    func resourceCacheInfo() -> (String?, NSDate?) {
        var e: String?
        var d: NSDate?
        if let eTag = self.allHeaderFields["ETag"] as? String {
            e = eTag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        if let lastModified = self.allHeaderFields["Last-Modified"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, dd LLL yyyy hh:mm:ss zzz"
            if let date = dateFormatter.dateFromString(lastModified) {
                d = date
            }
        }
        return (e, d)
    }
}

extension Request {

    public static func ObjectMapperSerializer<T: GitHubObject>(keyPath: String?, mapToObject object: T? = nil, context: MapContext? = nil) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }

            if let status = response?.statusCode {
                if status < 200 || status >= 300 {
                    let failureReason = NSHTTPURLResponse.localizedStringForStatusCode(status)
                    var userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    if let d = data {
                        if let body = String(data: d, encoding: NSUTF8StringEncoding) {
                            userInfo[NSLocalizedDescriptionKey] = body
                        }
                    }
                    let error = NSError(domain: AuthorizationRequest.Domain, code: status, userInfo: userInfo)
                    return .Failure(error)
                }
            }

            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: Error.Domain, code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
//                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }

            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)

            let JSONToMap: AnyObject?
            if let keyPath = keyPath where keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }
            let (e, d) = (response?.resourceCacheInfo())!

            if let object = object {
                if let eTag = e {
                    object.eTag = eTag
                }
                if let date = d {
                    object.lastModified = date
                }
                Mapper<T>().map(JSONToMap, toObject: object)
                return .Success(object)
            } else if let parsedObject = Mapper<T>(context: context).map(JSONToMap) {
                if let eTag = e {
                    parsedObject.eTag = eTag
                }
                if let date = d {
                    parsedObject.lastModified = date
                }
                return .Success(parsedObject)
            }

            let failureReason = "ObjectMapper failed to serialize response."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: Error.Domain, code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
//            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }

    /**
     Adds a handler to be called once the request has finished.

     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter object:            An object to perform the mapping on to
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.

     - returns: The request.
     */

    public func responseObject<T: GitHubObject>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.ObjectMapperSerializer(keyPath, mapToObject: object, context: context), completionHandler: completionHandler)
    }
    
    public static func GithubArraySerializer<T: Mappable>(keyPath: String?, context: MapContext? = nil) -> ResponseSerializer<GitHubArray<T>, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }

            if let status = response?.statusCode {
                if status < 200 || status >= 300 {
                    let failureReason = NSHTTPURLResponse.localizedStringForStatusCode(status)
                    var userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    if let d = data {
                        if let body = String(data: d, encoding: NSUTF8StringEncoding) {
                            userInfo[NSLocalizedDescriptionKey] = body
                        }
                    }
                    let error = NSError(domain: AuthorizationRequest.Domain, code: status, userInfo: userInfo)
                    return .Failure(error)
                }
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: Error.Domain, code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
                //                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            let JSONToMap: AnyObject?
            if let keyPath = keyPath where keyPath.isEmpty == false {
                JSONToMap = result.value?.valueForKeyPath(keyPath)
            } else {
                JSONToMap = result.value
            }
            
            let ret = GitHubArray<T>()
            let (e, d) = (response?.resourceCacheInfo())!
            if let etag = e {
                ret.eTag = etag
            }
            if let date = d {
                ret.lastModified = date
            }
            if let link = response?.findLink(relation: "pre") {
                ret.prePageLink = link.uri
            }
            if let link = response?.findLink(relation: "next") {
                ret.nextPageLink = link.uri
            }
            if let link = response?.findLink(relation: "first") {
                ret.firstPageLink = link.uri
            }
            if let link = response?.findLink(relation: "last") {
                ret.lastPageLink = link.uri
            }
            
            if let parsedObject = Mapper<T>(context: context).mapArray(JSONToMap){
                ret.array = parsedObject
                return .Success(ret)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: Error.Domain, code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
            //            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    
    public func responseArray<T: Mappable>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: Response<GitHubArray<T>, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.GithubArraySerializer(keyPath, context: context), completionHandler: completionHandler)
    }

}
