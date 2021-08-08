//
//  AppDelegate.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.defaultBlueColor()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.defaultBlueColor(),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)]
        
        UIBarButtonItem.appearance().tintColor = UIColor.defaultBlueColor()
        window?.backgroundColor = UIColor.white
        
        
        //hide item title for back button
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -UIScreen.main.bounds.width*2, vertical: 0), for:UIBarMetrics.default)

        
        let navigationVC = UINavigationController(rootViewController: EmployeesVC())
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()

        
        return true
    }



}

