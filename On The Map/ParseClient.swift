//
//  ParseClient.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/2/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

class ParseClient : HTTPClient {
    
    static let sharedInstance = ParseClient()
    
    let kStudentLocationUrl = "https://api.parse.com/1/classes/StudentLocation"
    
    let kParseAppIdHeader = "X-Parse-Application-Id"
    let kParseRestApiKeyHeader = "X-Parse-REST-API-Key"
    
    let kParseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let kParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    
    /*
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
    if error != nil { // Handle error...
    return
    }
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }
    task.resume()
    */
    
    func getStudentLocations(successHandler: (studentLocations:[StudentLocation]) -> Void, failureHandler: () -> Void) {
        let httpHeaders = [kParseAppIdHeader: kParseAppId, kParseRestApiKeyHeader : kParseRestApiKey]
        self.get(kStudentLocationUrl, httpHeaders: httpHeaders, completionHandler: {
            data, response, error in
            if self.responseSuccessful(response, error: error) {
                if let data = data {
                    successHandler(studentLocations: self.convertDataToStudentLocations(data))
                }
            }
        })
    }
    
    func postStudentLocation(location: StudentLocation, successHandler: () -> Void, failureHandler: () -> Void) {
        
    }
    
    private func convertDataToStudentLocations(data: NSData) -> [StudentLocation] {
        var locations: [StudentLocation] = []
        
        let parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            parsedResult = nil
            print("Could not parse the data as JSON: '\(data)'")
            return locations
        }
        
        guard let results = parsedResult["results"] as? [[String: AnyObject]] else {
            print("Could not find results in Udacity API response: \(parsedResult)")
            return locations
        }
        
        for result in results {
            if let location = dictionaryToStudentLocation(result) {
                locations.append(location)
            }
        }
        
        
        return locations
    }
    
    private func dictionaryToStudentLocation(dictionary: [String: AnyObject]) -> StudentLocation? {
        var objectId: String
        var uniqueKey: String
        var firstName: String
        var lastName: String
        var mapString: String
        var mediaURL: String
        var latitude: Float
        var longitude: Float
        var createdAt: NSDate
        var updatedAt: NSDate
        
        if let oId = dictionary["objectId"] as? String {
            objectId = oId
        }
        
        if let uKey = dictionary["uniqueKey"] as? String {
            
        }
        
        
        return nil
    }
    
}
