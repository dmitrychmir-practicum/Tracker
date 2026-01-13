//
//  TabBarItem.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

enum TabBarItem {
    case trackerList
    case statistics
    
    var controller: UIViewController {
        let controller: UIViewController
        switch self {
            case .trackerList:
            controller = TrackerListViewController()
            controller.tabBarItem = UITabBarItem(title: Constants.tabBarTrackerItem, image: Constants.tabBarTrackerItemImage, tag: 0)
        case .statistics:
            controller = StatisticsViewController()
            controller.tabBarItem = UITabBarItem(title: Constants.tabBarStatisticsItem, image: Constants.tabBarStatisticsItemImage, tag: 1)
        }
        
        return controller
    }
}
