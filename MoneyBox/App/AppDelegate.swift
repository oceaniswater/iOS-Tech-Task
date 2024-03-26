//
//  AppDelegate.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import UIKit
import Networking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator : AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController.init()
        appCoordinator = AppCoordinator(navigationController: navigationCon)
        appCoordinator?.start()
        window?.rootViewController = navigationCon
        window?.makeKeyAndVisible()
        return true
    }
}

