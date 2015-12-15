//
//  StudentLocationCache.swift
//  On The Map
//
//  Created by Victor Guthrie on 12/10/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation

class StudentLocationCache {
    
    static let sharedInstance: StudentLocationCache = StudentLocationCache()
    
    var locations : [StudentLocation]
    var loaded = false
    
    init(){
        locations = []
    }
    
    func updateLocations(locations: [StudentLocation]) {
        self.locations = locations
        loaded = true
    }
    
}
