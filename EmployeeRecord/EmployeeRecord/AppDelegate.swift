//
//  AppDelegate.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit
import RealmSwift

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

        self.configureRealm()

        let navigationVC = UINavigationController(rootViewController: EmployeesVC())
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        return true
    }
    func configureRealm() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
//        print("reaml path: \(Realm.Configuration.defaultConfiguration.fileURL)")
    }


}

