//
//  UdacityUser.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/4/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

struct StudentLocation {
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
    
    init(objectId: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double){
        self.objectId = objectId
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double){
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}