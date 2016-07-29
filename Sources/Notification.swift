//
//  Notification.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/29.
//
//

import Foundation
import ObjectMapper

public class Notification: GitHubObject {

    required public init?(_ map: Map) {
        super.init(map)
    }

    override public func mapping(map: Map) {
        super.mapping(map)
    }
}