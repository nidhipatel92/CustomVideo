//
//  AppDelegate.swift
//  CustomVideo
//
//  Created by Nidhi on 1/1/18.
//  Copyright © 2018 CreoleStudios. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldRotate = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let navigationController = self.window?.rootViewController as? UINavigationController
        if (navigationController?.viewControllers.last is ViewController) {
            let secondController = navigationController?.viewControllers.last as! ViewController
            if secondController.isPresented {
                return .portrait
            }else{
               return .landscape
            }
        }
        else {
            return .portrait
        }
    }

//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//
//        if self.window?.rootViewController?.presentedViewController is ViewController {
//
//            let secondController = self.window!.rootViewController!.presentedViewController as! ViewController
//
//            if secondController.isPresented {
//                return UIInterfaceOrientationMask.all;
//            } else {
//                return UIInterfaceOrientationMask.portrait;
//            }
//        } else {
//            return UIInterfaceOrientationMask.portrait;
//        }
//
//    }
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if shouldRotate == true {
//            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.portrait.rawValue)))
//        } else {
//            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.RawValue(Int(UIInterfaceOrientationMask.landscapeLeft.rawValue)))
//        }
//        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
//            if (rootViewController.responds(to: Selector(("canRotate")))) {
//                // Unlock landscape view orientations for this view controller
//                return .allButUpsideDown;
//            }
//        }
//
//        // Only allow portrait (standard behaviour)rootViewController.respondsToSelector(Selector("canRotate"))
//        return .portrait;
//    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of:UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
}

