//
//  AppDelegate.swift
//  NineNewsArticles
//
//  Created by Abdullah Al-Ashi on 3/2/2023.
//

import UIKit

//https://stackoverflow.com/a/74933432 XCode issue to be resolved by apple
// "This method should not be called on the main thread as it may lead to UI unresponsiveness."
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    #if DEBUG
        registerDefaultsFromSettingsBundle()
    #endif
        return true
    }
    
    #if DEBUG
        func registerDefaultsFromSettingsBundle() {
            func register(from dict: NSDictionary) {
                let preferences: NSArray = dict["PreferenceSpecifiers"] as! NSArray
                let defaults: [String: AnyObject] = preferences.compactMap { value -> (String, AnyObject)? in
                    guard let value = value as? [String: AnyObject] else {
                        return nil
                    }
                    
                    guard let key: String = value["Key"] as? String, let value = value["DefaultValue"] else {
                        return nil
                    }
                    
                    return (key, value)
                }
                    .reduce(into: [:]) { $0[$1.0] = $1.1 }
                    .filter { UserDefaults.standard.value(forKey: $0.key).isNil }
                
                UserDefaults.standard.register(defaults: defaults)
            }
            
            guard let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle") else {
                return
            }
            
            let plists: [String] = [
                "Root"
            ]
            
            plists.forEach {
                if let dic = NSDictionary(contentsOfFile: "\(settingsBundle)/\($0).plist") {
                    register(from: dic)
                } else {
                    assertionFailure("\(settingsBundle)/\($0).plist")
                }
            }
        }
    #endif

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

