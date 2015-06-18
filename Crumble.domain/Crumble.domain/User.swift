//
//  User.swift
//  Crumble.domain
//
//  Created by Fhict on 11/06/15.
//  Copyright (c) 2015 Fhict. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String!
    var title: String?
    var profileImage: String?
    var friends = [User: Bool]()
    var followers: [User]
    var following = [User: Bool]()
    var crumbles = [Crumble]()
    var allowFollowers = true
    
    init(name: String!, title: String?){
        self.name = name
        self.title = title
        self.friends = [:]
        self.followers = []
        self.following = [:]
        self.crumbles = []
    }
    func changeProfileImage(profileImage: String) {
        self.profileImage = profileImage
    }
    func changeTitle(newTitle: String) {
        self.title = newTitle
    }
    func findFriend(name: String) {
        var foundUser: User?
        var inList = false
        for (friend, showInformation) in friends {
            if (name == friend.name) {
                inList = true
            }
            if (inList == false) {
                foundUser = friend
                break;
            }
        }
        return foundUser
    }
    func findFavourite(name: String) {
        var foundUser: User?
        var inList = false
        for (favourite) in followers {
            if (name == favourite.name) {
                inList = true
            }
            if (inList == false) {
                foundUser = favourite
                break;
            }
        }
        return foundUser
    }
    // Add a crumble to the user
    func addCrumble(title: String!, text: String!, image: String) {
        self.crumbles.append(Crumble(title: title, text: text, image: image))
    }
    // Delete a crumble from the list
    func delCrumble(crumble: Crumble) -> Bool{
        var found = false
        for i in 1...self.crumbles.count {
            if (crumble.title == self.crumbles[i].title) {
                self.crumbles.removeAtIndex(i)
                return true
            }
        }
        return false
    }
    // Add follower to follower list if user isn't in the list yet
    func addFollower(user: User) {
        var found = false
        for i in 1...self.followers.count {
            if (user.name == self.followers[i].name) {
                found == true
            }
        }
        if (!found) {
            self.followers.append(user)
        }
    }
    // Delete follower from follower list if user is in the list
    func delFollower(user: User) -> Bool {
        for i in 1...self.followers.count {
            if(user.name == self.followers[i].name && user.title == self.followers[i].title) {
                self.followers.removeAtIndex(i)
                return true
            }
        }
        return false
    }
    // Add follower to follower dictionary if user isn't in it yet
    func addFriend(user: User) {
        var found = false
        if(self.friends.isEmpty) {
            self.friends[user] = false
        }
        else {
            for userLoop in self.friends.keys {
                if (userLoop.name == user.name) {
                    found == true
                    break;
                }
            }
            if (!found) {
                self.friends[user] = false
            }
        }
    }
    // Delete follower from follower dictionary if user is in it
    func delFriend(user: User) -> Bool {
        for (userLoop, followed) in friends {
            if(user.name == userLoop.name) {
                self.friends[user] = nil
                return true
            }
        }
        return false
    }
    // Add a user to the following dictionary
    // If the dictionary is empty; user is always added to the dictionary. Else user is added if he isn't in the dictionary already
    func addFollowing(user: User) {
        if(self.following.isEmpty) {
            self.following[user] = false
        }
        else {
            var userFound = false
            for userLoop in self.following.keys {
                if (userLoop.name == user.name) {
                    userFound == true
                    break;
                }
            }
            if (!userFound) {
                self.following[user] = false
            }
        }
    }
    // Remove user key from the following dictionary if the user parameter is in the dictionary
    func delFollowing(user: User) -> Bool {
        for (userLoop, followed) in following {
            if (userLoop == user) {
                following[user] = nil
                return true
            }
        }
        return false
    }
    // See crumbles of friend user
    func showFriendsCrumbles(friend: User){
        for (userLoop, followed) in friends {
            if (userLoop == friend) {
                friends[userLoop] = true
            }
        }
    }
    // See crumbles of following user
    func showFollowingCrumbles(followingUser: User) {
        for(userLoop, followed) in following {
            if (userLoop == followingUser) {
                following[userLoop] = true
            }
        }
    }
    // Determines the popularity of a user
    func popularity() -> Int {
        return followers.count
    }
    // Change if you want to allow followers. If false: user will have to accept a follower request
    func changeAllowFollowers() {
        self.allowFollowers = !self.allowFollowers
    }
    
}
