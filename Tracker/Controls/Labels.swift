//
//  Labels.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

enum NavigationBarLabels {
    case title
    
    var label: UILabel {
        let label = UILabel()
        switch self {
            case .title:
            label.text = Constants.trackersListTitle
            label.font = UIFont.systemFont(ofSize: 31, weight: .bold)
            label.textColor = .Colors.text
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 41),
                label.widthAnchor.constraint(equalToConstant: 254)
            ])
        }
        
        return label
    }
}

enum TitleLabels: String {
    case typeSelector = "Создание трекера"
    case regular = "Новая привычка"
    case notRegular = "Новое нерегулярное событие"
    case schedule = "Расписание"
    case category = "Категория"
    
    @discardableResult func addLabelToView(controller: UIViewController) -> UILabel {
        let label = self.label
        controller.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            label.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: 38)
        ])
        
        return label
    }
    
    private var label: UILabel {
        let titleLabel = UILabel()
        titleLabel.text = self.rawValue
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        return titleLabel
    }
}

enum WarningLabels: String {
    case maxNameLength = "Ограничение 38 символов"
    
    var label: UILabel {
        let label = UILabel()
        label.text = self.rawValue
        label.textColor = .Colors.ypRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 22),
            label.widthAnchor.constraint(equalToConstant: 286)
        ])
        return label
    }
}
