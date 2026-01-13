//
//  TrackerViewModel+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import Foundation

extension TrackerViewModel {
    var entity: Tracker? {
        guard let name = self.name,
              let color = self.color,
              let emoji = self.emoji else {
            return nil
        }
        
        return Tracker(id: UUID(), name: name, color: color, emoji: emoji, schedule: self.schedule)
    }
}
