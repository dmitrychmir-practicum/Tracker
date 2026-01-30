//
//  TrackerMap+Extension.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 23.01.2026.
//

import CoreData

extension Tracker {
    func mapToEntity() -> TrackerCD {
        let trackerDataService = TrackerDataService.shared
        let entity = trackerDataService.createTracker()
        entity.id = id
        entity.name = name
        entity.emoji = emoji.rawValue
        entity.color = color.uiColor.toString()
        
        if let schedule = schedule, let proxy = try? Json.encode(schedule) {
            entity.schedule = proxy as Data
        } else {
            entity.schedule = nil
        }
        
        return entity
    }
}

extension TrackerCD {
    func mapToModel() -> Tracker {
        guard let id, let name, let color, let emoji else {
            return Tracker(id: UUID(), name: "", color: .green, emoji: .smilingFace, schedule: nil)
        }
        
        let schedule = self.schedule ?? Data()
        var scheduleSet: Set<Schedule>
        
        do {
            scheduleSet = try Json.decode(Set<Schedule>.self, from: schedule)
        } catch {
            scheduleSet = []
        }
        
        return Tracker(
            id: id,
            name: name,
            color: Colors.getEnum(hexStr: color),
            emoji: Emojis.getEnum(fromString: emoji),
            schedule: scheduleSet
        )
    }
}
