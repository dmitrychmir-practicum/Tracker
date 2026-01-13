//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

final class ScheduleViewController: UIViewController {
    private var titleLabel: UILabel!
    private let scheduleTable = Tables.schedule.table
    private let okButton = TrackerEditButtons.ok.button
    private var selected: Set<Schedule>
    private var presenter: TrackerEditPresenterProtocol?
    
    // MARK: - Ctor
    
    init(presenter: TrackerEditPresenterProtocol?) {
        self.presenter = presenter
        self.selected = self.presenter?.trackerModel?.schedule ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - Setup
private extension ScheduleViewController {
    func setupView() {
        view.backgroundColor = .Colors.backgroundView
        setupTitle()
        setupButtons()
        setupScheduleTable()
    }
    
    func setupTitle() {
        titleLabel = TitleLabels.schedule.addLabelToView(controller: self)
    }
    
    func setupButtons() {
        view.addSubview(okButton)
        okButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.presenter?.update(schedule: self.selected)
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])    }
    
    func setupScheduleTable() {
        view.addSubview(scheduleTable)
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.register(ScheduleCell.self, forCellReuseIdentifier: Constants.scheduleCellReuseIdentifier)
        NSLayoutConstraint.activate([
            scheduleTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTable.heightAnchor.constraint(equalToConstant: CGFloat(7) * 75),
        ])
    }
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Schedule.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
              let cell = tableView.dequeueReusableCell(withIdentifier: Constants.scheduleCellReuseIdentifier, for: indexPath) as? ScheduleCell else {
            return UITableViewCell()
        }
        
        let dayIndex = (indexPath.row + 2) % 7
        let cellIdx = dayIndex == 0 ? 7 : dayIndex
        let isOn = selected.contains(Schedule.getDayByNumber(cellIdx))
        
        cell.configureCell(for: indexPath, action: UIAction(handler: { _ in
            
            let selectedDay = Schedule.getDayByNumber(cellIdx)
            if cell.switchView.isOn {
                self.selected.insert(selectedDay)
            } else {
                self.selected.remove(selectedDay)
            }
        }), isOn: isOn)
        
        return cell
    }
}

