//
//  UdacityUser.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/4/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    static let dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        return formatter
    }()
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double){
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(fromDictionary dictionary: [String : AnyObject]) {
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        latitude = (dictionary["latitude"] as! NSNumber).doubleValue
        longitude = (dictionary["longitude"] as! NSNumber).doubleValue
        
        if let createdAtString = dictionary["createdAt"] as? String, createdAtDate = StudentLocation.dateFormatter.dateFromString(createdAtString) {
            createdAt = createdAtDate
        }
        
        if let updatedAtString = dictionary["updatedAt"] as? String, updatedAtDate = StudentLocation.dateFormatter.dateFromString(updatedAtString) {
            updatedAt = updatedAtDate
        }
    }
    
    /**
      returns a JSON representation of this
        StudentLocation
    */
    func asJsonString() -> String {
        var fields = [
            "\"firstName\": \"\(firstName)\"",
            "\"lastName\": \"\(lastName)\"",
            "\"mapString\": \"\(mapString)\"",
            "\"mediaURL\": \"\(mediaURL)\"",
            "\"latitude\": \(latitude)",
            "\"longitude\": \(longitude)"
        ]
        if let key = uniqueKey {
            fields.append("\"uniqueKey\": \"\(key)\"")
        }
        return "{ \(fields.joinWithSeparator(",")) }"
    }
}