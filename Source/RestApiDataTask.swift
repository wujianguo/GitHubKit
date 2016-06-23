//
//  RestApiDataTask.swift
//  WhistleGou
//
//  Created by wujianguo on 16/6/10.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import Foundation

class RestApiDataTask<RequestType: RequestBase, ResponseType: ResponseBase> {

    var task: NSURLSessionDataTask?
    func startTaskWithRequest(request: RequestType, completionQueue: dispatch_queue_t?, completion:((response: ResponseType) -> Void)?) {
        task = NSURLSession.sharedSession().dataTaskWithRequest(request.buildRequest(), completionHandler: { (data, response, error) in
            if let queue = completionQueue {
                dispatch_async(queue, { 
                    completion?(response: ResponseType(data: data, response: response, error: error))
                })
            } else {
                completion?(response: ResponseType(data: data, response: response, error: error))
            }
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}
