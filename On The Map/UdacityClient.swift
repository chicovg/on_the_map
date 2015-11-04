//
//  UdacityClient.swift
//  On The Map
//
//  Holds logic related to Udacity web services
//
//  Created by Victor Guthrie on 11/2/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

class UdacityClient : HTTPClient {
    
    static let sharedInstance = UdacityClient()
    
    let kUdacityBaseUrl = "https://www.udacity.com/api"
    let kSessionPath = "/session"
    let kUsersPath = "/users"
    
    let kXsrfCookieName = "XSRF-TOKEN"
    let kXsrfTokenKey = "X-XSRF-TOKEN"
    
    /** Uses the Udacity session API to create a new session
        If the request is successful ..
        If the request fails, the specified failure handler will be executed
     */
    func postNewSession(email: String, password: String, successHandler: () -> Void, failureHandler: () -> Void){
        let url = kUdacityBaseUrl + kSessionPath
        let httpHeaders: [String: String] = ["Accept":"application/json", "Content-Type":"application/json"]
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        post(url, httpHeaders: httpHeaders, httpBody: httpBody, completionHandler: {
            data, response, error in
            
            if self.responseSuccessful(response, error: error) {
                if let data = data {
                    /*  success:
                    Optional({"account": {"registered": true, "key": "628108572"}, "session": {"id": "1478090449S3f8b6354fb908708e7d0677bbdf1482e", "expiration": "2016-01-02T12:40:49.018640Z"}}) */
                    /* failure:
                    Optional({"status": 403, "error": "Account not found or invalid credentials."}) */
                    
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                    // TODO do I store the session id ??
                    
                    successHandler()
                    return
                }
            }
            failureHandler()
        })
    }
    
    /** Uses the Udacity session API to delete the current session info (i.e. log out)
        If the request is successful ..
        If the request fails, the specified failure handler will be executed
    */
    func deleteSession(successHandler: () -> Void, failureHandler: () -> Void) {
        let url = kUdacityBaseUrl + kSessionPath
        var httpHeaders: [String: String] = [:]
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let xsrfCookie = sharedCookieStorage.cookies!.filter({(cookie) in cookie.name == kXsrfCookieName}).first
        if let cookie = xsrfCookie {
            httpHeaders[kXsrfTokenKey] = cookie.value
        }
        delete(url, httpHeaders: httpHeaders, completionHandler: {
            data, response, error in

            if self.responseSuccessful(response, error: error) {
                if let data = data {
                    
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                    print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                    // TODO do I store the session id ??
                    
                    successHandler()
                    return
                }
            }
            failureHandler()
        })
    }
    /*
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/3903878747")!)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
    if error != nil { // Handle error...
    return
    }
    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
    println(NSString(data: newData, encoding: NSUTF8StringEncoding))
    }
    */
    func getUserData(userId: String?, successHandler: () -> Void, failureHandler: () -> Void) {
        if let userId = userId {
            let url = kUdacityBaseUrl + kUsersPath + userId
            
            get(url, httpHeaders: nil, completionHandler: {
                data, response, error in
                
                if self.responseSuccessful(response, error: error) {
                    if let data = data {
                        
                        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                        print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                        // TODO do I store the session id ??
                        
                        successHandler()
                        return
                    }
                }
                failureHandler()
            })
        } else {
            print("Cannot get user data because user id was not provided")
        }
    }
    
    
    
}