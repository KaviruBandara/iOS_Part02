//
//  BadgeModel.swift
//  HouseHarmony
//
//  Achievement badge model
//

import Foundation
import SwiftUI

enum BadgeType: String, Codable {
    case milestone = "Milestone"
    case streak = "Streak"
    case category = "Category"
    case special = "Special"
}

struct BadgeModel: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var description: String
    var icon: String // SF Symbol or emoji
    var type: BadgeType
    var requirement: Int // Number needed to unlock
    var colorHex: String
    var isUnlocked: Bool
    var unlockedAt: Date?
    
    var color: Color {
        Color(hex: colorHex) ?? .gray
    }
    
    init(
        id: String,
        name: String,
        description: String,
        icon: String,
        type: BadgeType,
        requirement: Int,
        colorHex: String,
        isUnlocked: Bool = false,
        unlockedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.type = type
        self.requirement = requirement
        self.colorHex = colorHex
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
    }
}

// MARK: - Badge Definitions
extension BadgeModel {
    static let allBadges: [BadgeModel] = [
        // Milestone Badges
        BadgeModel(
            id: "first_task",
            name: "First Steps",
            description: "Complete your first task",
            icon: "star.fill",
            type: .milestone,
            requirement: 1,
            colorHex: "#FFD700"
        ),
        BadgeModel(
            id: "tasks_10",
            name: "Getting Started",
            description: "Complete 10 tasks",
            icon: "10.circle.fill",
            type: .milestone,
            requirement: 10,
            colorHex: "#FF6B6B"
        ),
        BadgeModel(
            id: "tasks_25",
            name: "Helper",
            description: "Complete 25 tasks",
            icon: "25.circle.fill",
            type: .milestone,
            requirement: 25,
            colorHex: "#FF6B6B"
        ),
        BadgeModel(
            id: "tasks_50",
            name: "Hard Worker",
            description: "Complete 50 tasks",
            icon: "50.circle.fill",
            type: .milestone,
            requirement: 50,
            colorHex: "#FF6B6B"
        ),
        BadgeModel(
            id: "tasks_100",
            name: "Chore Champion",
            description: "Complete 100 tasks",
            icon: "crown.fill",
            type: .milestone,
            requirement: 100,
            colorHex: "#FFD700"
        ),
        
        // Streak Badges
        BadgeModel(
            id: "streak_3",
            name: "3-Day Streak",
            description: "Complete tasks for 3 days in a row",
            icon: "flame.fill",
            type: .streak,
            requirement: 3,
            colorHex: "#FF8C42"
        ),
        BadgeModel(
            id: "streak_7",
            name: "Week Warrior",
            description: "Complete tasks for 7 days in a row",
            icon: "flame.fill",
            type: .streak,
            requirement: 7,
            colorHex: "#FF6B35"
        ),
        BadgeModel(
            id: "streak_14",
            name: "Fortnight Force",
            description: "Complete tasks for 14 days in a row",
            icon: "flame.fill",
            type: .streak,
            requirement: 14,
            colorHex: "#FF5722"
        ),
        BadgeModel(
            id: "streak_21",
            name: "Habit Builder",
            description: "Complete tasks for 21 days in a row",
            icon: "flame.fill",
            type: .streak,
            requirement: 21,
            colorHex: "#FF4500"
        ),
        BadgeModel(
            id: "streak_30",
            name: "Monthly Master",
            description: "Complete tasks for 30 days in a row",
            icon: "flame.fill",
            type: .streak,
            requirement: 30,
            colorHex: "#DC143C"
        ),
        
        // Points Badges
        BadgeModel(
            id: "points_100",
            name: "Century Club",
            description: "Earn 100 points",
            icon: "dollarsign.circle.fill",
            type: .milestone,
            requirement: 100,
            colorHex: "#4ECDC4"
        ),
        BadgeModel(
            id: "points_500",
            name: "Point Collector",
            description: "Earn 500 points",
            icon: "dollarsign.circle.fill",
            type: .milestone,
            requirement: 500,
            colorHex: "#4ECDC4"
        ),
        BadgeModel(
            id: "points_1000",
            name: "Point Master",
            description: "Earn 1000 points",
            icon: "dollarsign.circle.fill",
            type: .milestone,
            requirement: 1000,
            colorHex: "#FFD700"
        ),
        
        // Category Badges
        BadgeModel(
            id: "kitchen_master",
            name: "Kitchen Master",
            description: "Complete 20 kitchen tasks",
            icon: "fork.knife.circle.fill",
            type: .category,
            requirement: 20,
            colorHex: "#FF6B6B"
        ),
        BadgeModel(
            id: "clean_freak",
            name: "Clean Freak",
            description: "Complete 20 bathroom tasks",
            icon: "sparkles",
            type: .category,
            requirement: 20,
            colorHex: "#4ECDC4"
        ),
        
        // Special Badges
        BadgeModel(
            id: "early_bird",
            name: "Early Bird",
            description: "Complete a task before 8 AM",
            icon: "sunrise.fill",
            type: .special,
            requirement: 1,
            colorHex: "#FFD93D"
        ),
        BadgeModel(
            id: "night_owl",
            name: "Night Owl",
            description: "Complete a task after 10 PM",
            icon: "moon.stars.fill",
            type: .special,
            requirement: 1,
            colorHex: "#9D84B7"
        ),
        BadgeModel(
            id: "team_player",
            name: "Team Player",
            description: "Help complete tasks claimed by others",
            icon: "person.3.fill",
            type: .special,
            requirement: 5,
            colorHex: "#A8E6CF"
        )
    ]
}
