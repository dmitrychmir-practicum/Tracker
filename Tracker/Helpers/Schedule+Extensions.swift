//
//  Schedule+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

extension Set<Schedule> {
    func daysToString() -> String {
        if self.count == 7 {
            return "Все дни"
        }
        
        let sorted = self.sorted {
            Schedule.sortedDaysOfWeek.firstIndex(of: $0)! < Schedule.sortedDaysOfWeek.firstIndex(of: $1)!
        }
        return sorted.map { $0.short}.joined(separator: ", ")
    }
}
