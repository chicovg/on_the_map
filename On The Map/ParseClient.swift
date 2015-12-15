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
    
    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        return formatter
    }()
    
    let kStudentLocationUrl = "https://api.parse.com/1/classes/StudentLocation"
    
    let kParseAppIdHeader = "X-Parse-Application-Id"
    let kParseRestApiKeyHeader = "X-Parse-REST-API-Key"
    
    let kParseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let kParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    /** 
     
     */
    func getStudentLocations(successHandler: (studentLocations:[StudentLocation]) -> Void, failureHandler: () -> Void) {
        let httpHeaders = [kParseAppIdHeader: kParseAppId, kParseRestApiKeyHeader : kParseRestApiKey]
        self.get(kStudentLocationUrl, httpHeaders: httpHeaders, completionHandler: {
            data, response, error in
            if self.responseSuccessful(response, error: error) {
                if let data = data {
                    successHandler(studentLocations: self.convertDataToStudentLocations(data))
                }
            } else {
                failureHandler()
            }
        })
    }
    
    /**
     
     */
    func postStudentLocation(location: StudentLocation, successHandler: () -> Void, failureHandler: () -> Void) {
        let httpHeaders = [kParseAppIdHeader: kParseAppId, kParseRestApiKeyHeader : kParseRestApiKey]
        let httpBody = location.asJsonString()
        self.post(kStudentLocationUrl, httpHeaders: httpHeaders, httpBody: httpBody, completionHandler: {
            data, response, error in
            if self.responseSuccessful(response, error: error) {
                successHandler()
            } else {
                failureHandler()
            }
        })
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
            locations.append(StudentLocation(fromDictionary: result))
        }
        
        return locations
    }
    
}
