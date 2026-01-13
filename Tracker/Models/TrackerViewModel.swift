//
//  TrackerViewModel.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

struct TrackerViewModel {
    var name: String?
    var category: TrackerCategory?
    var color: Colors?
    var emoji: Emojis?
    var schedule: Set<Schedule>?
    
    init(name: String? = nil, category: TrackerCategory? = nil, color: Colors? = nil, emoji: Emojis? = nil, schedule: Set<Schedule>? = nil) {
        self.name = name
        self.category = category
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    var isValidRegular: Bool {
        guard let schedule, let name, let _ = category, let _ = color, let _ = emoji, !schedule.isEmpty, name != "" else { return false }
        
        return true
    }
    
    var isValidNotRegular: Bool {
        guard let name, let _ = category, let _ = color, let _ = emoji, name != "" else { return false }
        
        return true
    }
}
