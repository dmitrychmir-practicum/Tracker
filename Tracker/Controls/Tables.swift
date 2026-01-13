//
//  Tables.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

enum Tables {
    case buttons
    case schedule
    
    var table: UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = .Colors.tableCellBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        switch self {
        case .buttons:
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            tableView.layer.cornerRadius = 16
        case .schedule:
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            tableView.layer.cornerRadius = 16
        }
        
        return tableView
    }
    
    func makeButtonsTable(_ trackerType: TrackerType) -> UITableView {
        guard self == .buttons else { fatalError("Wrong table") }
        
        let rowCount = trackerType == .regular ? 2 : 1
        let table = self.table
        
        NSLayoutConstraint.activate([
            table.heightAnchor.constraint(equalToConstant: CGFloat(rowCount) * 75)
        ])
        
        return table
    }
}
