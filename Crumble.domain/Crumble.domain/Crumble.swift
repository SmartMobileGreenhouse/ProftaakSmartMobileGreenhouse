//
//  Crumble.swift
//  Crumble.domain
//
//  Created by Fhict on 11/06/15.
//  Copyright (c) 2015 Fhict. All rights reserved.
//

import UIKit

class Crumble: NSObject {
    var title: String!
    var text: String!
    var image: String?
    var location: String?
    var notification = false
    
    init(title: String!, text: String!, image: String) {
        self.title = title
        self.text = text
        self.image = image
    }
    // Set the location of a crumble
    func setLocation(location: String) {
        self.location = location
    }
    // Set if you want to recieve notifications from a crumble
    func setNotification() {
        self.notification = !self.notification
    }
    
    
}
