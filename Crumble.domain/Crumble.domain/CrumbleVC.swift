//
//  CrumbleVC.swift
//  Crumble.domain
//
//  Created by Fhict on 11/06/15.
//  Copyright (c) 2015 Fhict. All rights reserved.
//

import UIKit

class CrumbleVC: UIViewController {
    var loggedInUser: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFriends()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadFriends() {
        for (friendUser, showInformation) in loggedInUser?.friends {
            friendUser.name // SetText
            friendUser.title // SetText
            friendUser.profileImage // SetText
            showInformation // SetSlider
        }
    }
    func loadFavourites() {
        for (favUser, showInformation) in loggedInUser?.following {
            favUser.name // SetText
            favUser.title // SetText
            favUser.profileImage // SetText
            showInformation // SetSlider
        }
    }
    func findUser(name: String) {
        loggedInUser?.findFavourite(<#name: String#>)
        loggedInUser?.findFriend(<#name: String#>)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
