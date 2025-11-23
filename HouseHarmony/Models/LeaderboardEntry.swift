//
//  LeaderboardEntry.swift
//  HouseHarmony
//
//  Leaderboard entry model for ranking users
//

import Foundation
import SwiftUI

enum LeaderboardPeriod: String, CaseIterable {
    case allTime = "All Time"
    case monthly = "This Month"
    case weekly = "This Week"
    case daily = "Today"
}

struct LeaderboardEntry: Identifiable, Equatable {
    let id: UUID
    var userId: UUID
    var userName: String
    var userAvatar: String
    var userColor: String
    var rank: Int
    var points: Int
    var tasksCompleted: Int
    var streak: Int
    var badgeCount: Int
    
    var color: Color {
        Color(hex: userColor) ?? .blue
    }
    
    var rankEmoji: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "🏅"
        }
    }
    
    init(
        id: UUID = UUID(),
        userId: UUID,
        userName: String,
        userAvatar: String,
        userColor: String,
        rank: Int,
        points: Int,
        tasksCompleted: Int,
        streak: Int,
        badgeCount: Int
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.userAvatar = userAvatar
        self.userColor = userColor
        self.rank = rank
        self.points = points
        self.tasksCompleted = tasksCompleted
        self.streak = streak
        self.badgeCount = badgeCount
    }
    
    init(from user: UserModel, rank: Int) {
        self.id = UUID()
        self.userId = user.id
        self.userName = user.name
        self.userAvatar = user.avatar
        self.userColor = user.colorTheme
        self.rank = rank
        self.points = user.totalPoints
        self.tasksCompleted = user.tasksCompleted
        self.streak = user.currentStreak
        self.badgeCount = user.badgesEarned.count
    }
}

// MARK: - Sample Data
extension LeaderboardEntry {
    static let samples: [LeaderboardEntry] = [
        LeaderboardEntry(
            userId: UUID(),
            userName: "Emma",
            userAvatar: "👧",
            userColor: "#A8E6CF",
            rank: 1,
            points: 890,
            tasksCompleted: 89,
            streak: 21,
            badgeCount: 6
        ),
        LeaderboardEntry(
            userId: UUID(),
            userName: "Sarah",
            userAvatar: "👩‍💼",
            userColor: "#4ECDC4",
            rank: 2,
            points: 680,
            tasksCompleted: 68,
            streak: 14,
            badgeCount: 5
        ),
        LeaderboardEntry(
            userId: UUID(),
            userName: "Alex",
            userAvatar: "👨‍🎓",
            userColor: "#FF6B6B",
            rank: 3,
            points: 450,
            tasksCompleted: 45,
            streak: 7,
            badgeCount: 3
        ),
        LeaderboardEntry(
            userId: UUID(),
            userName: "Mike",
            userAvatar: "👨‍🍳",
            userColor: "#FFD93D",
            rank: 4,
            points: 320,
            tasksCompleted: 32,
            streak: 3,
            badgeCount: 2
        )
    ]
}
