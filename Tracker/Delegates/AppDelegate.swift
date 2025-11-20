//
//  AppDelegate.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let scene = UISceneConfiguration(
            name: "tabBar",
            sessionRole: connectingSceneSession.role
        )
        scene.delegateClass = SceneDelegate.self
        
        return scene
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
}

