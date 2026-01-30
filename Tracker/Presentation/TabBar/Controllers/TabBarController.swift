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
        
        guard let trackerListController = TabBarItem.trackerList.controller as? TrackerListViewController,
              let statisticsController = TabBarItem.statistics.controller as? StatisticsViewController else {
            assertionFailure("Не удалось создать контроллеры")
            return
        }

        trackerListController.configure(TrackerListPresenter(trackerService: TrackerCoreDataService.shared))
        
        viewControllers = [trackerListController, statisticsController]
        self.selectedIndex = 0
    }
}
