//
//  HTTPClient.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/2/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

class HTTPClient {
    
    /**
        Executes a GET request with the specified url and headers
        The completion handler is executed after the request returns
    */
    func get(url: String, httpHeaders: [String: String]?, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequest(buildRequest(url, method: "GET", httpHeaders: httpHeaders, httpBody: nil), completionHandler: completionHandler)
    }
    
    /**
        Executes a POST request with the specified url, headers, and request body
        The completion handler is executed after the request returns
    */
    func post(url: String, httpHeaders: [String: String]?, httpBody: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequest(buildRequest(url, method: "POST", httpHeaders: httpHeaders, httpBody: httpBody), completionHandler: completionHandler)
    }
    
    /**
        Executes a PUT request with the specified url, headers, and request body
        The completion handler is executed after the request returns
    */
    func put(url: String, httpHeaders: [String: String]?, httpBody: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequest(buildRequest(url, method: "PUT", httpHeaders: httpHeaders, httpBody: httpBody), completionHandler: completionHandler)
    }
    
    /**
        Executes a DELETE request with the specified url, and headers
        The completion handler is executed after the request returns
    */
    func delete(url: String, httpHeaders: [String: String]?, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequest(buildRequest(url, method: "DELETE", httpHeaders: httpHeaders, httpBody: nil), completionHandler: completionHandler)
    }
    
    /**
        Checks the error object and response object to see if the request was successful
    */
    func responseSuccessful(response: NSURLResponse?, error: NSError?) -> Bool {
        guard (error == nil) else {
            print("There was an error with your request: \(error)")
            return false
        }
        
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            if let response = response as? NSHTTPURLResponse {
                print("Your request returned an invalid response! Status code: \(response.statusCode)!")
            } else if let response = response {
                print("Your request returned an invalid response! Response: \(response)!")
            } else {
                print("Your request returned an invalid response!")
            }
            return false
        }
        return true
    }
    
    /**
        Parses NSData and returns a JSON object 
    */
    func dataToJson(data: NSData) -> AnyObject? {
        var parsedResult: AnyObject? = nil
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            print("Could not parse session response: '\(data)'")
        }
        return parsedResult
    }
    
    private func sendRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    private func buildRequest(url: String, method: String, httpHeaders: [String: String]?, httpBody: String?) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        
        if let headers = httpHeaders {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = httpBody {
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return request
    }
    
}
