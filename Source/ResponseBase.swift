//
//  ResponseBase.swift
//  WhistleGou
//
//  Created by wujianguo on 16/6/10.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import Foundation

class ResponseBase {
    
    var error: NSError?
    
    required init(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if error != nil {
            self.error = error
            return
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
            if let dic = json as? NSDictionary {
                self.responseDictionary(dic)
            } else if let array = json as? NSArray {
                self.responseArray(array)
            }
        } catch let jsonError as NSError {
            self.error = jsonError
        }
    }
    
    func responseDictionary(dic: NSDictionary) {
        print(dic)
    }
    
    func responseArray(array: NSArray) {
        print(array)
    }

}
