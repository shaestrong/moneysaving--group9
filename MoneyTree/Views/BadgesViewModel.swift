//
//  BadgesViewModel.swift
//  MoneyTree
//
//  Created by Stephany Ceron on 27/03/24.
//

import Foundation
import Observation

@Observable
final class BadgesViewModel {
    var store:BadgeStore
    
    init(store: BadgeStore = BadgeStore.badgesStore) {
        self.store = store
    }
    
    var listEarnedBadges: [Badge]{
        return store.badges.filter{ $0.isEarned }
    }
    
    private func findConsecutiveDays(for entries: [Entry]) -> Int {
        let sortedEntries = entries.sorted(by: { $0.date < $1.date })
        var consecutiveDays = 1
        var previousDate: Date?
        
        for entry in sortedEntries {
            guard let currentDate = entry.date.startOfDay else { continue }
            
            if let prevDate = previousDate {
                if Calendar.current.isDate(prevDate, inSameDayAs: currentDate) {
                    continue
                }
                
                if let days = Calendar.current.dateComponents([.day], from: prevDate, to: currentDate).day, days == 1 {
                    consecutiveDays += 1
                    print(consecutiveDays)
                } else {
                    consecutiveDays = 1
                }
            }
            
            previousDate = currentDate
        }
        
        return consecutiveDays
    }
    
    private func markAchievementAsEarned(name: String) {
        if let badgeIndex = store.badges.firstIndex(where: { $0.name == name }) {
            store.badges[badgeIndex].isEarned = true
        }
    }
    
    func checkAchievements(goals: [Goal]) {
        for goal in goals {
            // Check for three consecutive savings days
            let consecutiveDays = findConsecutiveDays(for: goal.entries)
            
            if consecutiveDays >= 3 {
                markAchievementAsEarned(name: "Three Consecutive Savings Days")
            }
            
            if goal.progress >= 1.0 {
                markAchievementAsEarned(name: "First Grown Tree")
            }
        }
        if goals.count > 0 {
            markAchievementAsEarned(name: "First Tree")
        }
    }
    
    func resetAchievements() {
        for index in store.badges.indices {
            store.badges[index].isEarned = false
        }
    }
}
