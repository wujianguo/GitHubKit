//
//  RequestBase.swift
//  WhistleGou
//
//  Created by wujianguo on 16/6/10.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import Foundation

class RequestBase {

    func baseURL() -> NSURL {
        return NSURL(string: "https://api.github.com/users/octocat/orgs")!
    }
    
    func buildRequest() -> NSURLRequest {
        return NSURLRequest(URL: self.baseURL())
    }
}
