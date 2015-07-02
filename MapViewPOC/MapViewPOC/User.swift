//
//  User.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 30-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var username: String
    var profilename: String
    var imagePath: String
    var image: UIImage?
    var genre: String
    
    init(username: String, profilename: String, imagePath: String, genre: String) {
        self.username = username
        self.profilename = profilename
        self.imagePath = imagePath
        self.image = UIImage(named: "default")
        self.genre = genre
    }
}
