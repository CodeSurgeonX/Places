//
//  MapAnnotations.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation : NSObject, MKAnnotation {
    let title: String?
    let rating : String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, rating : String ,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.rating = rating
        super.init()
    }
    
    var subtitle: String? {
        return self.rating
    }
}
