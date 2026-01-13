//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    private var schedule: Schedule?
    private var uiAction: UIAction?
    private var isOn: Bool = false
    var switchView = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configureCell(for indexPath: IndexPath, action: UIAction, isOn: Bool) {
        self.uiAction = action
        self.schedule = Schedule.allCases[indexPath.row]
        self.isOn = isOn
        setupCell()
        setupSwitch()
    }
}

private extension ScheduleCell {
    func setupCell() {
        self.textLabel?.text = schedule?.rawValue
        self.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.backgroundColor = .Colors.tableCellBackground
        self.selectionStyle = .none
    }
    
    func setupSwitch() {
        guard let uiAction else { return }
        
        switchView.onTintColor = .Colors.toggleBackground
        switchView.addAction(uiAction, for: .valueChanged)
        switchView.isOn = isOn
        
        self.accessoryView = switchView
    }
}
