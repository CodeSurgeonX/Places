//
//  MapEntity.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation
import MapKit
class MapEntity : Decodable {
    var name : String
    var rating : Double
    var lat : Double
    var long : Double
    var imageReference : String?
    
    //    enum CodingKeys: String, CodingKey {
    //        case name = "name"
    //        case rating = "rating"
    //        case lat = "lat"
    //        case long = "lng"
    //    }
    
    init(name : String, rating : Double, lat:Double, long : Double) {
        self.name = name
        self.rating = rating
        self.lat = lat
        self.long = long
    }
    
    init(jsonData : [String:Any]){
        self.name = (jsonData["name"] as? String) ?? "Default"
        self.rating = Double(truncating: (jsonData["rating"] as? NSNumber) ?? 0.0) 
        self.lat = 0.0
        self.long = 0.0
        if let geometry = jsonData["geometry"] as? [String:Any], let location = geometry["location"] as? [String:Any] {
            self.lat = (location["lat"] as? Double) ?? 0.0
            self.long = (location["lng"] as? Double) ?? 0.0
        }
        if let photos = jsonData["photos"] as? [[String:Any]], let first = photos.first {
            self.imageReference = first["photo_reference"] as? String
        }
    }
    
    func getImageDownloadLink() -> String? {
        if let reference = self.imageReference {
            let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(constants.maxImageWidth)&photoreference=\(reference)&key=\(constants.key)"
            return url
        }else {
            return nil
        }
        
        
    }
    
    
    func getMapRepresentableAnnotation() -> MapAnnotation? {
        let lat = CLLocationDegrees(exactly: self.lat)
        let long = CLLocationDegrees(exactly: self.long)
        if let _ = lat, let _ = long {
            let coord = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let annotation = MapAnnotation(title: self.name,rating: String(self.rating) ,coordinate: coord)
            return annotation
        }
        return nil
    }
}
