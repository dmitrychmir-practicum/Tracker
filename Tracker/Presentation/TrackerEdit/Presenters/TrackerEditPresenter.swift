//
//  TrackerEditPresenter.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

final class TrackerEditPresenter: TrackerEditPresenterProtocol {
    
    var trackerModel: TrackerViewModel?
    var view: TrackerEditViewProtocol?

    private(set) var trackerService: TrackerServiceProtocol?
    
    // MARK: - Ctor
    init(trackerService: TrackerServiceProtocol? = TrackerService.shared) {
        self.trackerService = trackerService
        
        let category = self.trackerService?.getCategoryByIndex(0) ?? TrackerCategory(title: Constants.defaultTrackerCategoryTitle, trackers: [])
        let color = Colors.allCases.randomElement() ?? Colors.green
        let emoji = Emojis.allCases.randomElement() ?? Emojis.smilingFace
        trackerModel = TrackerViewModel(name: "", category: category, color: color, emoji: emoji, schedule: [])
    }
    
    // MARK: - Methods
    
    func update(name: String?) {
        let proxyModel = TrackerViewModel(
            name: name,
            category: trackerModel?.category,
            color: trackerModel?.color,
            emoji: trackerModel?.emoji,
            schedule: trackerModel?.schedule
        )
        
        trackerModel = proxyModel
        modelIsUpdated()
    }
    
    func update(category: TrackerCategory) {
        let proxyModel = TrackerViewModel(
            name: trackerModel?.name,
            category: category,
            color: trackerModel?.color,
            emoji: trackerModel?.emoji,
            schedule: trackerModel?.schedule
        )
        
        trackerModel = proxyModel
        modelIsUpdated()
        view?.table.reloadData()
    }
    
    func update(color: Colors?) {
        let proxyModel = TrackerViewModel(
            name: trackerModel?.name,
            category: trackerModel?.category,
            color: color,
            emoji: trackerModel?.emoji,
            schedule: trackerModel?.schedule
        )
        
        trackerModel = proxyModel
        modelIsUpdated()
    }
    
    func update(emoji: Emojis?) {
        let proxyModel = TrackerViewModel(
            name: trackerModel?.name,
            category: trackerModel?.category,
            color: trackerModel?.color,
            emoji: emoji,
            schedule: trackerModel?.schedule
        )
        
        trackerModel = proxyModel
        modelIsUpdated()
    }
    
    func update(schedule: Set<Schedule>?) {
        let proxyModel = TrackerViewModel(
            name: trackerModel?.name,
            category: trackerModel?.category,
            color: trackerModel?.color,
            emoji: trackerModel?.emoji,
            schedule: schedule
        )
        
        trackerModel = proxyModel
        modelIsUpdated()
        view?.table.reloadData()
    }
    
    func modelIsValid() -> Bool {
        (view?.trackerType == .regular && trackerModel?.isValidRegular ?? false) || (view?.trackerType == .notRegular && trackerModel?.isValidNotRegular ?? false)
    }
    
    func saveTracker(tracker: Tracker) {
        guard let categoryTitle = trackerModel?.category?.title, let category = trackerService?.getCategoryByTitle(categoryTitle)
                else { return }
        
        var proxyCategory: TrackerCategory
        var trackers = category.trackers
        if !trackers.contains(where: { $0.id == tracker.id }) {
            trackers.append(tracker)
            proxyCategory = TrackerCategory(title: category.title, trackers: trackers)
        } else {
            //Обновление существующего трекера на случай редактирования
            guard let idx = trackers.firstIndex(of: tracker) else { return }
            trackers[idx] = tracker
            proxyCategory = TrackerCategory(title: category.title, trackers: trackers)
        }
        
        trackerService?.updateCategory(proxyCategory)
    }
    
    func toogleShowWarning(isOn: Bool) {
        guard let view, let constraint = view.nameFieldHeightConstraint else { return }
        
        if isOn {
            constraint.constant = 113
            UIView.animate(withDuration: 0) {
                view.scrollView.layoutIfNeeded()
            }
        } else {
            constraint.constant = 75
        }
        
        view.nameFieldHeightConstraint = constraint
    }
    
    private func modelIsUpdated() {
        view?.toggleCreateButtonEnable(modelIsValid())
    }
}
