//
//  Constants.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

enum TabBarItem {
    case trackerList
    case statistics
    
    var item: UITabBarItem {
        switch self {
        case .trackerList:
            return UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), tag: 0)
        case .statistics:
            return UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), tag: 1)
        }
    }
}
