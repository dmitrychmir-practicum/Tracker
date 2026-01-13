//
//  TrackerListPresenterProtocol.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import Foundation

protocol TrackerListPresenterProtocol: AnyObject {
    var view: TrackerListViewProtocol? { get set }
    var categories: [TrackerCategory] { get }
    var trackerRecords: [TrackerRecord] { get }
    
    func viewDidLoad()
    func configure()
    func updateCollectionView()
    func addNewTracker()
    func changeDate()
    func pressCheckButton(tracker: Tracker)
    func getTotalFinishedCountByTracker(_ tracker: Tracker) -> Int
}
