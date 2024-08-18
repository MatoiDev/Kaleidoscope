//
//  AppDelegate.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 07.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let viewController: MainViewController = MainViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    
        return true
    }

}

