//
//  AppDelegate.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinator: MVVMCoordinator?
    var window: UIWindow?
    let navigationController = UINavigationController()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        coordinator = MVVMCoordinator(navigationController: navigationController)
        coordinator?.start()
        window?.rootViewController = navigationController
        
        return true
    }

}

