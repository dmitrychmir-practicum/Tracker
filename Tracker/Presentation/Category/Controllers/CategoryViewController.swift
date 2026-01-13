//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Colors.backgroundView
        TitleLabels.category.addLabelToView(controller: self)
    }
}
