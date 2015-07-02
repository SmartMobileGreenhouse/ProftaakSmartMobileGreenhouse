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
    var subscriptions: [User]
    
    init(username: String, profilename: String, imagePath: String, genre: String) {
        self.username = username
        self.profilename = profilename
        self.imagePath = imagePath
        self.image = UIImage(named: "default")
        self.genre = genre
        self.subscriptions = [User]()
    }
    
    // Add a user to the list of subscriptions if it is not in the list yet
    func subscribeToUser(subscription: User) -> Bool
    {
        for user:User in subscriptions
        {
            if(user.username == subscription.username)
            {
                return false
            }
        }
        
        self.subscriptions.append(subscription)
        // TODO: Add subscription to users subscriberlist in database
        return true
    }
    
    func unSubscribeToUser(subscription: User) -> Bool
    {
        var index = 0
        for user:User in subscriptions
        {
            if(user.username == subscription.username)
            {
                self.subscriptions.removeAtIndex(index)
                //TODO: Remove subscription from users subscriberlist in database
                return true
            }
            index++
        }
        return false
    }
}
