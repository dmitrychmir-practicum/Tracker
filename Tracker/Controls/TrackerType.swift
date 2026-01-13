//
//  TrackerType.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

enum TrackerType {
    case regular
    case notRegular
    
    private var button: UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .Colors.buttonDefaultBackground
        button.setTitleColor(.Colors.buttonDefaultText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch self {
        case .regular:
            button.setTitle(Constants.trackerTypeButtonTitleRegular, for: .normal)
        case .notRegular:
            button.setTitle(Constants.trackerTypeButtonTitleNotRegular, for: .normal)
        }
        
        return button
    }
    
    func makeButton(action: UIAction) -> UIButton {
        let button = self.button
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    func addLabelToView(controller: UIViewController) {
        switch self {
        case .regular:
            TitleLabels.regular.addLabelToView(controller: controller)
        case .notRegular:
            TitleLabels.notRegular.addLabelToView(controller: controller)
        }
    }
}
