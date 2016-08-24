//
//  GitHubAccount.swift
//  GitHubKit
//
//  Created by wujianguo on 16/7/26.
//
//

import Foundation
import UIKit
import SafariServices
import GitHubKit
import ObjectMapper

extension String {
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);

        CC_MD5(str!, strLen, result);

        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();

        return String(format: hash as String)
    }
}


class GitHubAccount {

    static let sharedInstance = GitHubAccount()
    
    class func config(clientID: String, scope: String) {
        sharedInstance.clientID = clientID
        sharedInstance.scope = scope
    }

    private var access_token: String?
    private var token_type: String?

    private var currentUserJsonFile: NSURL? {
        if let dir = NSFileManager.defaultManager().URLsForDirectory(.DocumentationDirectory, inDomains: .UserDomainMask).first {
            if !NSFileManager.defaultManager().fileExistsAtPath(dir.absoluteString) {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtURL(dir, withIntermediateDirectories: true, attributes: nil)
                } catch {

                }
            }
            return dir.URLByAppendingPathComponent("current_user.json")
        }
        return nil
    }

    private init() {
        // todo: save to keychain, icloud
        access_token = NSUserDefaults.standardUserDefaults().stringForKey("access_token")
        token_type = NSUserDefaults.standardUserDefaults().stringForKey("token_type")

        if let file = currentUserJsonFile {
            if let data = NSData(contentsOfURL: file) {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [.AllowFragments])
                    GitHubKit.currentUser = Mapper<User>(context: nil).map(json)!
                } catch {

                }
            }
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GitHubAccount.handleCurrentUserInfoNotification(_:)), name: GitHubCurrentUserInfoNotificationName, object: nil)


        GitHubAuthorization.config(access_token, token_type: token_type) { (completion) in
            self.authCompletion = completion

            self.timestamp = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
            self.state = self.sign(self.clientID, t: self.timestamp)

            let components = NSURLComponents(string: "https://github.com/login/oauth/authorize")!
            let query = [
                NSURLQueryItem(name: "client_id", value: self.clientID),
                NSURLQueryItem(name: "scope", value: self.scope),
                NSURLQueryItem(name: "state", value: self.state!),
                ]
            components.queryItems = query
            let url = components.URL!
            dispatch_async(dispatch_get_main_queue()) {
                self.authVC = SFSafariViewController(URL: url)
                let topVC = UIApplication.sharedApplication().topViewController
                topVC.presentViewController(self.authVC!, animated: true, completion: nil)
            }
        }
    }

    @objc func handleCurrentUserInfoNotification(notification: NSNotification) {
        if let file = currentUserJsonFile, user = GitHubKit.currentUser {
            do {
                try user.toJSONString()?.writeToURL(file, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {

            }
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: GitHubCurrentUserInfoNotificationName, object: nil)
    }
    

    private var timestamp: NSTimeInterval = 0
    private var state: String?
    private var authVC: SFSafariViewController?


    private func sign(key: String, t: NSTimeInterval) -> String {
        let origin = "\(key)\(timestamp)"
        return "\(origin.md5),\(timestamp)"
    }

    private func getQueryStringParameter(url: String, param: String) -> String? {
        if let url = NSURLComponents(string: url) {
            if let query = url.queryItems {
                return (query.filter { $0.name == param }).first?.value
            }
        }
        return nil
    }

    private var clientID: String! = nil
    private var scope: String! = nil

    private var authCompletion: AuthorizationCompletion?


    func openURL(url: NSURL) -> Bool {
        guard url.scheme == "wjggithub" && url.host == "auth" else { return false }
        access_token = getQueryStringParameter(url.absoluteString, param: "access_token")
        token_type = getQueryStringParameter(url.absoluteString, param: "token_type")

        NSUserDefaults.standardUserDefaults().setValue(access_token, forKey: "access_token")
        NSUserDefaults.standardUserDefaults().setValue(token_type, forKey: "token_type")

        authVC?.dismissViewControllerAnimated(true) {
            self.authCompletion?(access_token: self.access_token!, token_type: self.token_type)
            self.authVC = nil
            self.authCompletion = nil
        }
        return true
    }

    class func openURL(url: NSURL) -> Bool {
        return sharedInstance.openURL(url)
    }
}