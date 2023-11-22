//
//  Manager.swift
//  Tracker
//
//  Created by Muller Alexander on 21.11.2023.
//

import UIKit

protocol ManagerProtocol {
    func getCategories() -> [TrackerCategory]
    func updateCategories(newCategories: [TrackerCategory])
    func getWeekDay() -> [WeekDay]
}

final class ManagerStub: ManagerProtocol {
    static let shared = ManagerStub()
    
    private var categories: [TrackerCategory] = [TrackerCategory(nameCategory: "Важное", arrayTrackers: [
        Tracker(name: "Трекер1", color: .colorSelection1, emoji: "😱", schedule: [.monday, .wednesday, .sunday]),
        Tracker(name: "Трекер2", color: .colorSelection2, emoji: "🍏", schedule: [.wednesday]),
        Tracker(name: "Трекер3", color: .colorSelection3, emoji: "😡", schedule: [.sunday, .monday, .saturday, .wednesday]),
        Tracker(name: "Трекер4", color: .colorSelection4, emoji: "🙌", schedule: [.monday, .saturday,]),
        Tracker(name: "Трекер5", color: .colorSelection5, emoji: "🏓", schedule: [.thursday, .monday, .wednesday]),
        Tracker(name: "Трекер6", color: .colorSelection6, emoji: "🏝️", schedule: [.thursday])
    ])]
    
    private let weekDay: [WeekDay] = [.friday, .monday, .saturday, .sunday, .thursday, .tuesday, .wednesday]
    
    func getCategories() -> [TrackerCategory] {
        categories
    }
    
    func updateCategories(newCategories: [TrackerCategory]) {
        categories = newCategories
    }
    
    func getWeekDay() -> [WeekDay] {
        return weekDay
    }
}



