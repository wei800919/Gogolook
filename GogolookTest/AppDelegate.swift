//
//  AppDelegate.swift
//  GogolookTest
//
//  Created by Xidi on 2022/2/28.
//

import UIKit

var GogoLook: AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

