//
//  Types.swift
//  Places App
//
//  Created by Shashwat  on 05/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation

enum LocationState {
    case Success
    case Fail
}


struct constants {
    static var key = "AIzaSyBTBReGJAtxvsIPOYhzlaqfx99RdEkHyvk"
    static var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    static var maxImageWidth = "400"
}
