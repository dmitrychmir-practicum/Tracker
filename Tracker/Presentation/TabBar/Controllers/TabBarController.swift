//
//  TabBarController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackerListController = TrackerNavBarController()
        trackerListController.tabBarItem = TabBarItem.trackerList.item
        let statisticsController = StatisticsViewController()
        statisticsController.tabBarItem = TabBarItem.statistics.item
        viewControllers = [trackerListController, statisticsController]
        self.selectedIndex = 0
    }
}
