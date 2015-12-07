//
//  LocationAnnotation.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/13/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation : NSObject, MKAnnotation {
    let name: String
    let url: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, url: String, coordinate: CLLocationCoordinate2D){
        self.name = name
        self.coordinate = coordinate
        self.url = url
        
        super.init()
    }
    
    var title : String? {
        return name
    }
    
    var subtitle: String? {
        return url
    }
    
    
}
