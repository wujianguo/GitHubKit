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

    var access_token: String?
//    var scope: [String]?
    var token_type: String?

    private init() {
        // todo: save to keychain, icloud
        access_token = NSUserDefaults.standardUserDefaults().stringForKey("access_token")
        token_type = NSUserDefaults.standardUserDefaults().stringForKey("token_type")

        GitHubAuthorization.config(access_token, token_type: token_type) { (completion) in
            self.authCompletion = completion

            self.timestamp = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
            self.state = self.sign(self.clientID, t: self.timestamp)

            let scope = "user:email user:follow public_repo repo notifications read:org"

            let components = NSURLComponents(string: "https://github.com/login/oauth/authorize")!
            let query = [
                NSURLQueryItem(name: "client_id", value: self.clientID),
                NSURLQueryItem(name: "scope", value: scope),
                NSURLQueryItem(name: "state", value: self.state!),
                ]
            components.queryItems = query
            let url = components.URL!
            self.authVC = SFSafariViewController(URL: url)
            let topVC = UIApplication.sharedApplication().topViewController
            topVC.presentViewController(self.authVC!, animated: true, completion: nil)
        }
    }

    private var timestamp: NSTimeInterval = 0
    private var state: String?
    private var authVC: SFSafariViewController?


    func sign(key: String, t: NSTimeInterval) -> String {
        let origin = "\(key)\(timestamp)"
        return "\(origin.md5),\(timestamp)"
    }

    func getQueryStringParameter(url: String, param: String) -> String? {
        if let url = NSURLComponents(string: url) {
            if let query = url.queryItems {
                return (query.filter { $0.name == param }).first?.value
            }
        }
        return nil
    }

    private let clientID = "1234567890"
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