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
    
    let kUdacityBaseUrl = "https://www.udacity.com/api"
    let kSessionPath = "/session"
    
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
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                failureHandler()
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                failureHandler()
                return
            }
            
            if let data = data {
                /*  success:
                    Optional({"account": {"registered": true, "key": "628108572"}, "session": {"id": "1478090449S3f8b6354fb908708e7d0677bbdf1482e", "expiration": "2016-01-02T12:40:49.018640Z"}}) */
                /* failure:
                    Optional({"status": 403, "error": "Account not found or invalid credentials."}) */
                
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                // TODO do I store the session id ??
                
                successHandler()
            }
        })
    }
}