//
//  TrackerNavBarController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

final class TrackerNavBarController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = .black
        
        let mainViewController = TrackerListViewController()
        viewControllers = [mainViewController]
    }
}
