//
//  TrackerEditPresenterProtocol.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

protocol TrackerEditPresenterProtocol: AnyObject {
    var view: TrackerEditViewProtocol? { get set }
    var trackerModel: TrackerViewModel? { get }
    var trackerService: TrackerServiceProtocol? { get }
    
    func update(name: String?)
    func update(category: TrackerCategory)
    func update(color: Colors?)
    func update(emoji: Emojis?)
    func update(schedule: Set<Schedule>?)
    func modelIsValid() -> Bool
    func saveTracker(tracker: Tracker)
    func toogleShowWarning(isOn: Bool)
}
