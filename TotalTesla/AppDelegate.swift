//
//  AppDelegate.swift
//  TotalTesla
//
//  Created by Coldfin on 9/11/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        GIDSignIn.sharedInstance().clientID = "741617625136-fuq6m8fsmpck1ut7vmm35o3qeej4tj3a.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"WaDKokz8H0051g7bKt9tBgDXX", consumerSecret:"gIVIpYWgdviLaSBHpVO6sS4DQxafnTSaC4cF4A7n6lFxJ0TaNH")
        return true
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            _ = user.profile.givenName
            _ = user.profile.familyName
            _ = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
           FBSDKAppEvents.activateApp()
    }

    func application(_ app: UIApplication,open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appId = url.absoluteString.components(separatedBy: "/").first
        if(appId == "fb133906257260119:")
        {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else if (appId == "741617625136-fuq6m8fsmpck1ut7vmm35o3qeej4tj3a.apps.googleusercontent.com:"){
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else
        {
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
        
        
    }
    
    
}

