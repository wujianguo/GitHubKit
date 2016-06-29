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
            let characterSet = NSMutableCharacterSet.whitespaceCharacterSet()
            characterSet.addCharactersInString("\"")
            e = eTag.stringByTrimmingCharactersInSet(characterSet)
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

    public static func ObjectMapperSerializer<T: ResourceCacheInfo>(keyPath: String?, mapToObject object: T? = nil, context: MapContext? = nil) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
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
                    object.setEtag(eTag)
                }
                if let date = d {
                    object.setLastModified(date)
                }
                Mapper<T>().map(JSONToMap, toObject: object)
                return .Success(object)
            } else if let parsedObject = Mapper<T>(context: context).map(JSONToMap) {
                if let eTag = e {
                    parsedObject.setEtag(eTag)
                }
                if let date = d {
                    parsedObject.setLastModified(date)
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

    public func responseObject<T: ResourceCacheInfo>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.ObjectMapperSerializer(keyPath, mapToObject: object, context: context), completionHandler: completionHandler)
    }

    public static func ObjectMapperArraySerializer<T: ResourceCacheInfo>(keyPath: String?, context: MapContext? = nil) -> ResponseSerializer<[T], NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
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

            if let parsedObject = Mapper<T>(context: context).mapArray(JSONToMap){
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

     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.

     - returns: The request.
     */
    public func responseArray<T: ResourceCacheInfo>(queue queue: dispatch_queue_t? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.ObjectMapperArraySerializer(keyPath, context: context), completionHandler: completionHandler)
    }
}
