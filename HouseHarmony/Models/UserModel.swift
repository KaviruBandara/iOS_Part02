//
//  UserModel.swift
//  HouseHarmony
//
//  Multi-user profile model with gamification stats
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var avatar: String // emoji or SF Symbol name
    var colorTheme: String // hex color
    var totalPoints: Int
    var currentStreak: Int
    var longestStreak: Int
    var tasksCompleted: Int
    var badgesEarned: [String] // Badge IDs
    var createdAt: Date
    var lastActive: Date
    var isAdmin: Bool // Admin can add categories, tasks, and assign tasks
    
    // Computed properties
    var level: Int {
        return (totalPoints / 100) + 1
    }
    
    var progressToNextLevel: Double {
        let currentLevelPoints = (level - 1) * 100
        let nextLevelPoints = level * 100
        let progress = Double(totalPoints - currentLevelPoints) / Double(nextLevelPoints - currentLevelPoints)
        return min(max(progress, 0), 1)
    }
    
    var color: Color {
        Color(hex: colorTheme) ?? .blue
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        avatar: String,
        colorTheme: String,
        totalPoints: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        tasksCompleted: Int = 0,
        badgesEarned: [String] = [],
        createdAt: Date = Date(),
        lastActive: Date = Date(),
        isAdmin: Bool = false
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.colorTheme = colorTheme
        self.totalPoints = totalPoints
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.tasksCompleted = tasksCompleted
        self.badgesEarned = badgesEarned
        self.createdAt = createdAt
        self.lastActive = lastActive
        self.isAdmin = isAdmin
    }
    
    // Mutating methods
    mutating func addPoints(_ points: Int) {
        totalPoints += points
    }
    
    mutating func incrementTaskCount() {
        tasksCompleted += 1
    }
    
    mutating func updateStreak(increment: Bool) {
        if increment {
            currentStreak += 1
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
        } else {
            currentStreak = 0
        }
    }
    
    mutating func earnBadge(_ badgeId: String) {
        if !badgesEarned.contains(badgeId) {
            badgesEarned.append(badgeId)
        }
    }
    
    mutating func updateLastActive() {
        lastActive = Date()
    }
}

// MARK: - Sample Data
extension UserModel {
    static let samples: [UserModel] = [
        UserModel(
            name: "Alex",
            avatar: "Alex",  // Asset name from Assets.xcassets
            colorTheme: "#FF6B6B",
            totalPoints: 450,
            currentStreak: 7,
            longestStreak: 12,
            tasksCompleted: 45,
            badgesEarned: ["first_task", "streak_7", "points_100"],
            isAdmin: true  // Alex is also an admin
        ),
        UserModel(
            name: "Sarah",
            avatar: "Sarah",  // Asset name from Assets.xcassets
            colorTheme: "#4ECDC4",
            totalPoints: 680,
            currentStreak: 14,
            longestStreak: 14,
            tasksCompleted: 68,
            badgesEarned: ["first_task", "streak_7", "streak_14", "points_100", "points_500"],
            isAdmin: true  // Sarah is the admin (Mom)
        ),
        UserModel(
            name: "Mike",
            avatar: "Mike",  // Asset name from Assets.xcassets
            colorTheme: "#FFD93D",
            totalPoints: 320,
            currentStreak: 3,
            longestStreak: 9,
            tasksCompleted: 32,
            badgesEarned: ["first_task", "points_100"]
        ),
        UserModel(
            name: "Emma",
            avatar: "Emma",  // Asset name from Assets.xcassets
            colorTheme: "#A8E6CF",
            totalPoints: 890,
            currentStreak: 21,
            longestStreak: 21,
            tasksCompleted: 89,
            badgesEarned: ["first_task", "streak_7", "streak_14", "streak_21", "points_100", "points_500"]
        )
    ]
}
