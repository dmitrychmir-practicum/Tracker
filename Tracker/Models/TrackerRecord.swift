//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import Foundation

struct TrackerRecord: Hashable, Codable {
    let trackerId: UUID
    let date: Date
}
