//
//  AppDelegate.swift
//  Expenses
//
//  Created by Anna Sverdlova on 04.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var expenses: Expenses = Expenses()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window?.makeKeyAndVisible()
        return true
    }

}

