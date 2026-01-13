//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import Foundation

struct Tracker: Hashable {
    let id: UUID
    let name: String
    let color: Colors
    let emoji: Emojis
    let schedule: Set<Schedule>?
}
