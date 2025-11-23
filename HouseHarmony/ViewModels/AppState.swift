//
//  AppState.swift
//  HouseHarmony
//
//  Main application state manager
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var users: [UserModel] = []
    @Published var choreCategories: [ChoreCategory] = []
    @Published var showProfileSelection = true
    @Published var showTaskCompletion = false
    @Published var completedTask: TaskModel?
    
    private let persistence = PersistenceService.shared
    
    init() {
        loadData()
    }
    
    // MARK: - Data Loading
    func loadData() {
        users = persistence.loadUsers()
        choreCategories = persistence.loadChoreCategories()
        
        // If no users exist, create sample data
        if users.isEmpty {
            users = UserModel.samples
            persistence.saveUsers(users)
        }
        
        // If no chore categories exist, create sample data
        if choreCategories.isEmpty {
            choreCategories = ChoreCategory.samples
            persistence.saveChoreCategories(choreCategories)
        }
    }
    
    // MARK: - User Management
    func selectUser(_ user: UserModel) {
        currentUser = user
        showProfileSelection = false
        updateUserActivity(user.id)
    }
    
    func logoutCurrentUser() {
        currentUser = nil
        showProfileSelection = true
    }
    
    func updateUserActivity(_ userId: UUID) {
        if let index = users.firstIndex(where: { $0.id == userId }) {
            users[index].updateLastActive()
            persistence.saveUsers(users)
        }
    }
    
    func createUser(name: String, avatar: String, colorTheme: String) {
        let newUser = UserModel(
            name: name,
            avatar: avatar,
            colorTheme: colorTheme
        )
        users.append(newUser)
        persistence.saveUsers(users)
    }
    
    func updateUser(_ user: UserModel) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
            if currentUser?.id == user.id {
                currentUser = user
            }
            persistence.saveUsers(users)
        }
    }
    
    // MARK: - Task Management
    func completeTask(_ task: TaskModel, in categoryId: UUID) {
        guard let currentUser = currentUser else { return }
        
        // Find and update the task
        if let categoryIndex = choreCategories.firstIndex(where: { $0.id == categoryId }),
           let taskIndex = choreCategories[categoryIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            
            choreCategories[categoryIndex].tasks[taskIndex].complete(by: currentUser.id)
            
            // Award points to user
            if let userIndex = users.firstIndex(where: { $0.id == currentUser.id }) {
                users[userIndex].addPoints(task.points)
                users[userIndex].incrementTaskCount()
                users[userIndex].updateStreak(increment: true)
                
                // Check and award badges
                checkAndAwardBadges(for: userIndex)
                
                // Update current user
                self.currentUser = users[userIndex]
            }
            
            // Save changes
            persistence.saveChoreCategories(choreCategories)
            persistence.saveUsers(users)
        }
    }
    
    func claimTask(_ task: TaskModel, in categoryId: UUID) {
        guard let currentUser = currentUser else { return }
        
        if let categoryIndex = choreCategories.firstIndex(where: { $0.id == categoryId }),
           let taskIndex = choreCategories[categoryIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            
            choreCategories[categoryIndex].tasks[taskIndex].claim(by: currentUser.id)
            persistence.saveChoreCategories(choreCategories)
        }
    }
    
    func unclaimTask(_ task: TaskModel, in categoryId: UUID) {
        if let categoryIndex = choreCategories.firstIndex(where: { $0.id == categoryId }),
           let taskIndex = choreCategories[categoryIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            
            choreCategories[categoryIndex].tasks[taskIndex].unclaim()
            persistence.saveChoreCategories(choreCategories)
        }
    }
    
    // MARK: - Badge System
    private func checkAndAwardBadges(for userIndex: Int) {
        let user = users[userIndex]
        
        // Check milestone badges
        if user.tasksCompleted >= 1 && !user.badgesEarned.contains("first_task") {
            users[userIndex].earnBadge("first_task")
        }
        if user.tasksCompleted >= 10 && !user.badgesEarned.contains("tasks_10") {
            users[userIndex].earnBadge("tasks_10")
        }
        if user.tasksCompleted >= 25 && !user.badgesEarned.contains("tasks_25") {
            users[userIndex].earnBadge("tasks_25")
        }
        if user.tasksCompleted >= 50 && !user.badgesEarned.contains("tasks_50") {
            users[userIndex].earnBadge("tasks_50")
        }
        if user.tasksCompleted >= 100 && !user.badgesEarned.contains("tasks_100") {
            users[userIndex].earnBadge("tasks_100")
        }
        
        // Check streak badges
        if user.currentStreak >= 3 && !user.badgesEarned.contains("streak_3") {
            users[userIndex].earnBadge("streak_3")
        }
        if user.currentStreak >= 7 && !user.badgesEarned.contains("streak_7") {
            users[userIndex].earnBadge("streak_7")
        }
        if user.currentStreak >= 14 && !user.badgesEarned.contains("streak_14") {
            users[userIndex].earnBadge("streak_14")
        }
        if user.currentStreak >= 21 && !user.badgesEarned.contains("streak_21") {
            users[userIndex].earnBadge("streak_21")
        }
        if user.currentStreak >= 30 && !user.badgesEarned.contains("streak_30") {
            users[userIndex].earnBadge("streak_30")
        }
        
        // Check points badges
        if user.totalPoints >= 100 && !user.badgesEarned.contains("points_100") {
            users[userIndex].earnBadge("points_100")
        }
        if user.totalPoints >= 500 && !user.badgesEarned.contains("points_500") {
            users[userIndex].earnBadge("points_500")
        }
        if user.totalPoints >= 1000 && !user.badgesEarned.contains("points_1000") {
            users[userIndex].earnBadge("points_1000")
        }
    }
    
    // MARK: - Leaderboard
    func getLeaderboard(period: LeaderboardPeriod = .allTime) -> [LeaderboardEntry] {
        let sortedUsers = users.sorted { $0.totalPoints > $1.totalPoints }
        return sortedUsers.enumerated().map { index, user in
            LeaderboardEntry(from: user, rank: index + 1)
        }
    }
    
    // MARK: - Stats
    func getUserStats(for userId: UUID) -> UserStats? {
        guard let user = users.first(where: { $0.id == userId }) else { return nil }
        
        let completedTasks = choreCategories.flatMap { $0.tasks }.filter { $0.completedBy == userId }
        let categoryStats = Dictionary(grouping: completedTasks, by: { $0.category })
            .mapValues { $0.count }
        
        return UserStats(
            user: user,
            categoryBreakdown: categoryStats,
            recentTasks: Array(completedTasks.sorted { ($0.completedAt ?? Date()) > ($1.completedAt ?? Date()) }.prefix(5))
        )
    }
}

// MARK: - Supporting Types
struct UserStats {
    let user: UserModel
    let categoryBreakdown: [String: Int]
    let recentTasks: [TaskModel]
}
