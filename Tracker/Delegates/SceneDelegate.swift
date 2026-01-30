//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let trackerService: TrackerServiceProtocol = TrackerCoreDataService.shared
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        //Загружаем данные
        trackerService.loadData()
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
}

