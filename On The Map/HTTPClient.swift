//
//  HTTPClient.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/2/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

class HTTPClient {
    
    /*
        pass in:
            url
            args
            callback
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".dataUsingEncoding(NSUTF8StringEncoding)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
    if error != nil { // Handle error…
    return
    }
    let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
    println(NSString(data: newData, encoding: NSUTF8StringEncoding))
    }
    task.resume()

     */
    
    /**
        Executes a POST request with the specified url, headers, and request body
        The completion handler is executed after the request returns
    */
    func sendRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    func post(url: String, httpHeaders: [String: String], httpBody: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let u = NSURL(string: url)
        let request = NSMutableURLRequest(URL: u!)
        request.HTTPMethod = "POST"
        
        for (key, value) in httpHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        sendRequest(request, completionHandler: completionHandler)
    }
    
    
}
