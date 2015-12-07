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
        let httpBody = studentLocationToJsonString(location)
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
            if let location = dictionaryToStudentLocation(result) {
                locations.append(location)
            }
        }
        
        return locations
    }
    
    private func dictionaryToStudentLocation(dictionary: [String: AnyObject]) -> StudentLocation? {
        var studentLocation: StudentLocation? = nil
        
        // if required attributes are present, create StudentLocation struct, else return nil
        if let objectId = dictionary["objectId"] as? String,
            firstName = dictionary["firstName"] as? String,
            lastName = dictionary["lastName"] as? String,
            mapString = dictionary["mapString"] as? String,
            mediaURL = dictionary["mediaURL"] as? String,
            latitude = dictionary["latitude"] as? NSNumber,
            longitude = dictionary["longitude"] as? NSNumber {
                studentLocation = StudentLocation(objectId: objectId, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        } else {
            return nil
        }
        
        // add optional attributes if present
        if let uniqueKey = dictionary["uniqueKey"] as? String {
            studentLocation?.uniqueKey = uniqueKey
        }
        
        if let createdAtString = dictionary["createdAt"] as? String, createdAtDate = dateFormatter.dateFromString(createdAtString) {
            studentLocation?.createdAt = createdAtDate
        }
        
        if let updatedAtString = dictionary["updatedAt"] as? String, updatedAtDate = dateFormatter.dateFromString(updatedAtString) {
            studentLocation?.updatedAt = updatedAtDate
        }
        
        return studentLocation
    }
    
    private func studentLocationToJsonString(studentLocation: StudentLocation) -> String {
        return "{\"uniqueKey\": \"\(studentLocation.uniqueKey)\", " +
               " \"firstName\": \"\(studentLocation.firstName)\", " +
               " \"lastName\": \"\(studentLocation.lastName)\", " +
               " \"mapString\": \"\(studentLocation.mapString)\", " +
               " \"mediaURL\": \"\(studentLocation.mediaURL)\", " +
               " \"latitude\": \(studentLocation.latitude), " +
               " \"longitude\": \(studentLocation.longitude)}"
    }
    
}
