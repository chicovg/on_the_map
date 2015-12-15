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
    
    var currentUserKey: String?
    
    /** Uses the Udacity session API to create a new session
        If the request is successful ..
        If the request fails, the specified failure handler will be executed
     */
    func postNewSession(email: String, password: String, successHandler: () -> Void, failureHandler: (errorMsg: String) -> Void){
        let url = kUdacityBaseUrl + kSessionPath
        let httpHeaders: [String: String] = ["Accept":"application/json", "Content-Type":"application/json"]
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        post(url, httpHeaders: httpHeaders, httpBody: httpBody, completionHandler: {
            data, response, error in
            
            if self.responseSuccessful(response, error: error) {
                if let data = data {
                    
                    // subset response data!
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                    print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                    
                    // Parse data and get account details
                    guard let parsedResult = self.dataToJson(newData) as? [String: AnyObject] else {
                        print("Could not parse session response: '\(newData)'")
                        failureHandler(errorMsg: "Failed to get user data from Udacity")
                        return
                    }
                    
                    guard let account = parsedResult["account"] as? [String: AnyObject] else {
                        print("Could not get user account info from session response: '\(parsedResult)'")
                        failureHandler(errorMsg: "Failed to get user data from Udacity")
                        return
                    }
                    
                    guard let accountKey = account["key"] as? String else {
                        print("Could not get user key from account info in session response: '\(account)'")
                        failureHandler(errorMsg: "Failed to get user data from Udacity")
                        return
                    }
                    
                    self.currentUserKey = accountKey
                    successHandler()
                    return
                }
            } else {
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 403 {
                        failureHandler(errorMsg: "Invalid credentials")
                        return
                    } else if response.statusCode == 408 {
                        failureHandler(errorMsg: "Request Timeout")
                        return
                    }
                }
                
                if let err = error {
                    failureHandler(errorMsg: err.localizedDescription)
                } else {
                    failureHandler(errorMsg: "An unexpected exception occurred")
                }
            }
        })
    }
    
    /** 
     Uses the Udacity session API to create a new session using
     If the request is successful ..
     If the request fails, the specified failure handler will be executed
     */
    func postNewFacebookSession(token: String, successHandler: () -> Void, failureHandler: (errorMsg: String) -> Void){
        let url = kUdacityBaseUrl + kSessionPath
        let httpHeaders: [String: String] = ["Accept":"application/json", "Content-Type":"application/json"]
        let httpBody = "{\"facebook_mobile\": {\"access_token\": \"\(token)\"}}"
        
        post(url, httpHeaders: httpHeaders, httpBody: httpBody, completionHandler: {
            data, response, error in
            
            if self.responseSuccessful(response, error: error) {
                if let data = data {
                    
                    // subset response data!
                    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                    print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                    
                    // Parse data and get account details
                    guard let parsedResult = self.dataToJson(newData) as? [String: AnyObject] else {
                        print("Could not parse session response: '\(newData)'")
                        failureHandler(errorMsg: "Failed to get user data from Udacity")
                        return
                    }
                    
                    guard let account = parsedResult["account"] as? [String: AnyObject] else {
                        print("Could not get user account info from session response: '\(parsedResult)'")
                        failureHandler(errorMsg: "Failed to get user data from Udacity")
                        return
                    }
                    
                    guard let accountKey = account["key"] as? String else {
                        print("Could not get user key from account info in session response: '\(account)'")
                        failureHandler(errorMsg: "Failed to get user data from Udacity")
                        return
                    }
                    
                    self.currentUserKey = accountKey
                    successHandler()
                    return
                }
            } else {
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 403 {
                        failureHandler(errorMsg: "Invalid credentials")
                    } else if response.statusCode == 408 {
                        failureHandler(errorMsg: "Request Timeout")
                    }
                }
                failureHandler(errorMsg: "An unexpected error occurred")
            }
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
    func getUserData(userId: String?, successHandler: (studentInfo: StudentInfo) -> Void, failureHandler: () -> Void) {
        if let userId = userId {
            let url = kUdacityBaseUrl + kUsersPath + "/" + userId
            
            get(url, httpHeaders: nil, completionHandler: {
                data, response, error in
                
                if self.responseSuccessful(response, error: error) {
                    if let data = data {
                        
                        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                        if let studentInfo = self.studentLocationFromUserData(newData) {
                            successHandler(studentInfo: studentInfo)
                        } else {
                            print("Could not get Student Info from User Data!")
                            failureHandler()
                        }
                        
                        return
                    }
                }
                failureHandler()
            })
        } else {
            print("Cannot get user data because user id was not provided")
        }
    }
    
    private func studentLocationFromUserData(data: NSData) -> StudentInfo? {
        var studentInfo: StudentInfo? = nil
        // Parse data and student info
        guard let parsedResult = self.dataToJson(data) as? [String: AnyObject] else {
            print("Could not parse user data: '\(data)'")
            return studentInfo
        }
        
        guard let user = parsedResult["user"] as? [String: AnyObject] else {
            print("Could not get user from user data '\(parsedResult)'")
            return studentInfo
        }
        
        
        if let key = user["key"] as? String, let firstName = user["first_name"] as? String, lastName = user["last_name"] as? String {
            studentInfo = StudentInfo(uniqueKey: key, firstName: firstName, lastName: lastName)
        }
        
        return studentInfo
    }
    
    
}