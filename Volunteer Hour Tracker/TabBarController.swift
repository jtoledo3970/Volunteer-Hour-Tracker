//
//  TabBarController.swift
//  Volunteer Hour Tracker
//
//  Created by Administrator on 7/23/17.
//  Copyright © 2017 Toledo IT Solution's. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title!)
        if (item.title == "Information") {
            print("The information tab was selected")
        }
    }
}
