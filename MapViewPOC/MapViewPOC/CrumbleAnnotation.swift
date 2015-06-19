//
//  CrumbleAnnotation.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 18-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class CrumbleAnnotation: NSObject, MKAnnotation {
    
    var radius: CLLocationDistance
    var author: String
    var imagePath: String
    var crumbleText: String
    var coordinate: CLLocationCoordinate2D
    var id: Int
    var date: String
    var title: String
    
    init(latitude: Double, longitude: Double, identifier: Int, crumbleText: String, author: String, imagePath: String, date: String, title: String) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.id = identifier
        self.crumbleText = crumbleText
        self.author = author
        self.imagePath = imagePath
        self.date = date
        self.title = title
        self.radius = 50.0
    }
}