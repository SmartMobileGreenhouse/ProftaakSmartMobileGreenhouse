//
//  TabBarController.swift
//  MapViewPOC
//
//  Created by Eric de Regter on 19-06-15.
//  Copyright (c) 2015 Fontys. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        UITabBar.appearance().barTintColor = UIColor(red: 224/255, green: 172/255, blue: 37/255, alpha: 1)
        UITabBar.appearance().backgroundColor = UIColor(red: 224/255, green: 172/255, blue: 37/255, alpha: 1)
    }
}
