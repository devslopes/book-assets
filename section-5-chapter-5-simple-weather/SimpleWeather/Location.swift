//
//  Location.swift
//  SimpleWeather
//
//  Created by Jonny B on 10/21/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}

