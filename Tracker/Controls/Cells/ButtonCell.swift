//
//  ButtonCell.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class ButtonCell: UITableViewCell {
    //MARK: - Fields
    private let container = UIView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let arrow = UIImageView()

    //MARK: - Lyfecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func createCategoryButton(category: TrackerCategory?) {
        title.text = Constants.buttonSelectCategory
        subtitle.text = category?.title
        subtitle.isHidden = category == nil
    }
    
    func createScheduleButton(schedule: Set<Schedule>?) {
        title.text = Constants.buttonSelectSchedule
        guard let schedule else {
            subtitle.text = nil
            subtitle.isHidden = true
            return
        }
        
        subtitle.text = schedule.daysToString()
        subtitle.isHidden = false
    }
}

// MARK: - Setup
private extension ButtonCell {
    func setupCell() {
        contentView.backgroundColor = .Colors.tableCellBackground
        setupContainer()
        setupTitle()
        setupSubtitle()
        setupArrow()
        setupConstraints()
    }
    
    func setupContainer() {
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
    }
    
    func setupTitle() {
        title.font = .systemFont(ofSize: 17, weight: .regular)
        title.textColor = .Colors.text
        title.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(title)
    }
    
    func setupSubtitle() {
        subtitle.font = .systemFont(ofSize: 17, weight: .regular)
        subtitle.textColor = .Colors.textSubtitle
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(subtitle)
    }
    
    func setupArrow() {
        arrow.image = Constants.buttonSelectsArrow
        arrow.tintColor = .gray
        arrow.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(arrow)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            subtitle.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrow.widthAnchor.constraint(equalToConstant: 8),
            arrow.heightAnchor.constraint(equalToConstant: 13)
        ])
    }
}
