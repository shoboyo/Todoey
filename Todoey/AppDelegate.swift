//
//  AppDelegate.swift
//  Todoey
//
//  Created by Raileanu Razvan Andrei on 17/11/2018.
//  Copyright © 2018 MetaLanguage. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        
        do{
             _ = try Realm()
            
        }catch {
            print ("error initializing realm\(error)")
        }
        return true
    }


  
    
    
}

