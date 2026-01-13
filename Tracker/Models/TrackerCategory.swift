//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

struct TrackerCategory: Hashable, Equatable {
    let title: String
    let trackers: [Tracker]

    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title == rhs.title
    }
}
