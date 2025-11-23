//
//  AppStateTests.swift
//  HouseHarmonyTests
//
//  Unit tests for AppState ViewModel
//

import XCTest
import Combine
@testable import HouseHarmony

final class AppStateTests: XCTestCase {
    
    var appState: AppState!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        appState = AppState()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        appState = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testAppStateInitialization() {
        XCTAssertNotNil(appState)
        XCTAssertNil(appState.currentUser)
        XCTAssertTrue(appState.showProfileSelection)
        XCTAssertFalse(appState.showTaskCompletion)
        XCTAssertNil(appState.completedTask)
    }
    
    func testDataLoadedOnInitialization() {
        XCTAssertFalse(appState.users.isEmpty, "Users should be loaded on initialization")
        XCTAssertFalse(appState.choreCategories.isEmpty, "Chore categories should be loaded on initialization")
    }
    
    // MARK: - User Selection Tests
    
    func testSelectUser() {
        let user = appState.users.first!
        
        appState.selectUser(user)
        
        XCTAssertEqual(appState.currentUser?.id, user.id)
        XCTAssertFalse(appState.showProfileSelection)
    }
    
    func testSelectUserUpdatesLastActive() {
        let user = appState.users.first!
        let originalLastActive = user.lastActive
        
        Thread.sleep(forTimeInterval: 0.01)
        
        appState.selectUser(user)
        
        let updatedUser = appState.users.first { $0.id == user.id }
        XCTAssertNotNil(updatedUser)
        XCTAssertTrue(updatedUser!.lastActive > originalLastActive)
    }
    
    func testLogoutCurrentUser() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        XCTAssertNotNil(appState.currentUser)
        XCTAssertFalse(appState.showProfileSelection)
        
        appState.logoutCurrentUser()
        
        XCTAssertNil(appState.currentUser)
        XCTAssertTrue(appState.showProfileSelection)
    }
    
    // MARK: - User Management Tests
    
    func testCreateUser() {
        let initialCount = appState.users.count
        
        appState.createUser(
            name: "New User",
            avatar: "NewAvatar",
            colorTheme: "#123456"
        )
        
        XCTAssertEqual(appState.users.count, initialCount + 1)
        
        let newUser = appState.users.last
        XCTAssertNotNil(newUser)
        XCTAssertEqual(newUser?.name, "New User")
        XCTAssertEqual(newUser?.avatar, "NewAvatar")
        XCTAssertEqual(newUser?.colorTheme, "#123456")
    }
    
    func testUpdateUser() {
        var user = appState.users.first!
        user.totalPoints = 999
        user.name = "Updated Name"
        
        appState.updateUser(user)
        
        let updatedUser = appState.users.first { $0.id == user.id }
        XCTAssertNotNil(updatedUser)
        XCTAssertEqual(updatedUser?.totalPoints, 999)
        XCTAssertEqual(updatedUser?.name, "Updated Name")
    }
    
    func testUpdateCurrentUser() {
        var user = appState.users.first!
        appState.selectUser(user)
        
        user.totalPoints = 888
        appState.updateUser(user)
        
        XCTAssertEqual(appState.currentUser?.totalPoints, 888)
    }
    
    // MARK: - Task Claiming Tests
    
    func testClaimTask() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        let category = appState.choreCategories.first!
        var task = category.tasks.first { $0.isAvailable }!
        
        XCTAssertFalse(task.isClaimed)
        
        appState.claimTask(task, in: category.id)
        
        // Find the updated task
        let updatedCategory = appState.choreCategories.first { $0.id == category.id }!
        let updatedTask = updatedCategory.tasks.first { $0.id == task.id }!
        
        XCTAssertTrue(updatedTask.isClaimed)
        XCTAssertEqual(updatedTask.claimedBy, user.id)
    }
    
    func testUnclaimTask() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        // First claim it
        appState.claimTask(task, in: category.id)
        
        // Then unclaim it
        appState.unclaimTask(task, in: category.id)
        
        let updatedCategory = appState.choreCategories.first { $0.id == category.id }!
        let updatedTask = updatedCategory.tasks.first { $0.id == task.id }!
        
        XCTAssertFalse(updatedTask.isClaimed)
        XCTAssertNil(updatedTask.claimedBy)
    }
    
    // MARK: - Task Completion Tests
    
    func testCompleteTask() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        let initialPoints = user.totalPoints
        let initialTaskCount = user.tasksCompleted
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        let taskPoints = task.points
        
        appState.completeTask(task, in: category.id)
        
        // Check task is completed
        let updatedCategory = appState.choreCategories.first { $0.id == category.id }!
        let updatedTask = updatedCategory.tasks.first { $0.id == task.id }!
        XCTAssertTrue(updatedTask.isCompleted)
        XCTAssertEqual(updatedTask.completedBy, user.id)
        
        // Check user stats updated
        let updatedUser = appState.users.first { $0.id == user.id }!
        XCTAssertEqual(updatedUser.totalPoints, initialPoints + taskPoints)
        XCTAssertEqual(updatedUser.tasksCompleted, initialTaskCount + 1)
    }
    
    func testCompleteTaskUpdatesStreak() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        let initialStreak = user.currentStreak
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        appState.completeTask(task, in: category.id)
        
        let updatedUser = appState.users.first { $0.id == user.id }!
        XCTAssertEqual(updatedUser.currentStreak, initialStreak + 1)
    }
    
    func testCompleteTaskAwardsBadges() {
        // Create a new user with no badges
        appState.createUser(
            name: "Badge Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        let user = appState.users.last!
        appState.selectUser(user)
        
        XCTAssertTrue(user.badgesEarned.isEmpty)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        appState.completeTask(task, in: category.id)
        
        let updatedUser = appState.users.first { $0.id == user.id }!
        XCTAssertTrue(updatedUser.badgesEarned.contains("first_task"), "Should earn first task badge")
    }
    
    // MARK: - Badge Award Tests
    
    func testBadgeAwardedAt10Tasks() {
        appState.createUser(
            name: "Badge Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        var user = appState.users.last!
        user.tasksCompleted = 9
        appState.updateUser(user)
        appState.selectUser(user)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        appState.completeTask(task, in: category.id)
        
        let updatedUser = appState.users.first { $0.id == user.id }!
        XCTAssertTrue(updatedUser.badgesEarned.contains("tasks_10"))
    }
    
    func testBadgeAwardedAt100Points() {
        appState.createUser(
            name: "Badge Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        var user = appState.users.last!
        user.totalPoints = 95
        appState.updateUser(user)
        appState.selectUser(user)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable && $0.points >= 5 }!
        
        appState.completeTask(task, in: category.id)
        
        let updatedUser = appState.users.first { $0.id == user.id }!
        XCTAssertTrue(updatedUser.badgesEarned.contains("points_100"))
    }
    
    func testBadgeAwardedAt7DayStreak() {
        appState.createUser(
            name: "Badge Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        var user = appState.users.last!
        user.currentStreak = 6
        appState.updateUser(user)
        appState.selectUser(user)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        appState.completeTask(task, in: category.id)
        
        let updatedUser = appState.users.first { $0.id == user.id }!
        XCTAssertTrue(updatedUser.badgesEarned.contains("streak_7"))
    }
    
    // MARK: - Leaderboard Tests
    
    func testGetLeaderboard() {
        let leaderboard = appState.getLeaderboard()
        
        XCTAssertFalse(leaderboard.isEmpty)
        XCTAssertEqual(leaderboard.count, appState.users.count)
    }
    
    func testLeaderboardSortedByPoints() {
        let leaderboard = appState.getLeaderboard()
        
        for i in 0..<(leaderboard.count - 1) {
            XCTAssertGreaterThanOrEqual(
                leaderboard[i].points,
                leaderboard[i + 1].points,
                "Leaderboard should be sorted by points descending"
            )
        }
    }
    
    func testLeaderboardRanksCorrect() {
        let leaderboard = appState.getLeaderboard()
        
        for (index, entry) in leaderboard.enumerated() {
            XCTAssertEqual(entry.rank, index + 1, "Rank should match position")
        }
    }
    
    func testLeaderboardTopUser() {
        let leaderboard = appState.getLeaderboard()
        let topEntry = leaderboard.first!
        
        XCTAssertEqual(topEntry.rank, 1)
        
        // Verify it's actually the user with most points
        let maxPoints = appState.users.map { $0.totalPoints }.max()!
        XCTAssertEqual(topEntry.points, maxPoints)
    }
    
    // MARK: - User Stats Tests
    
    func testGetUserStats() {
        let user = appState.users.first!
        let stats = appState.getUserStats(for: user.id)
        
        XCTAssertNotNil(stats)
        XCTAssertEqual(stats?.user.id, user.id)
    }
    
    func testGetUserStatsForNonexistentUser() {
        let fakeUserId = UUID()
        let stats = appState.getUserStats(for: fakeUserId)
        
        XCTAssertNil(stats)
    }
    
    func testUserStatsCategoryBreakdown() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        // Complete a task
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        appState.completeTask(task, in: category.id)
        
        let stats = appState.getUserStats(for: user.id)
        XCTAssertNotNil(stats)
        XCTAssertFalse(stats!.categoryBreakdown.isEmpty)
    }
    
    // MARK: - Data Persistence Tests
    
    func testUsersPersistedAfterUpdate() {
        let initialCount = appState.users.count
        
        appState.createUser(
            name: "Persist Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        // Create new AppState instance to test persistence
        let newAppState = AppState()
        
        XCTAssertEqual(newAppState.users.count, initialCount + 1)
        XCTAssertTrue(newAppState.users.contains { $0.name == "Persist Test" })
    }
    
    // MARK: - Edge Case Tests
    
    func testCompleteTaskWithoutCurrentUser() {
        appState.logoutCurrentUser()
        XCTAssertNil(appState.currentUser)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        // Should not crash
        appState.completeTask(task, in: category.id)
        
        // Task should not be completed
        let updatedCategory = appState.choreCategories.first { $0.id == category.id }!
        let updatedTask = updatedCategory.tasks.first { $0.id == task.id }!
        XCTAssertFalse(updatedTask.isCompleted)
    }
    
    func testClaimTaskWithoutCurrentUser() {
        appState.logoutCurrentUser()
        XCTAssertNil(appState.currentUser)
        
        let category = appState.choreCategories.first!
        let task = category.tasks.first { $0.isAvailable }!
        
        // Should not crash
        appState.claimTask(task, in: category.id)
        
        // Task should not be claimed
        let updatedCategory = appState.choreCategories.first { $0.id == category.id }!
        let updatedTask = updatedCategory.tasks.first { $0.id == task.id }!
        XCTAssertFalse(updatedTask.isClaimed)
    }
    
    func testUpdateNonexistentUser() {
        let fakeUser = UserModel(
            id: UUID(),
            name: "Fake",
            avatar: "Fake",
            colorTheme: "#000000"
        )
        
        let initialCount = appState.users.count
        
        // Should not crash
        appState.updateUser(fakeUser)
        
        // Should not add the user
        XCTAssertEqual(appState.users.count, initialCount)
    }
    
    // MARK: - Multiple User Tests
    
    func testMultipleUsersCanClaimDifferentTasks() {
        let user1 = appState.users[0]
        let user2 = appState.users[1]
        
        let category = appState.choreCategories.first!
        let availableTasks = category.tasks.filter { $0.isAvailable }
        XCTAssertGreaterThan(availableTasks.count, 1, "Need at least 2 available tasks")
        
        let task1 = availableTasks[0]
        let task2 = availableTasks[1]
        
        // User 1 claims task 1
        appState.selectUser(user1)
        appState.claimTask(task1, in: category.id)
        
        // User 2 claims task 2
        appState.selectUser(user2)
        appState.claimTask(task2, in: category.id)
        
        let updatedCategory = appState.choreCategories.first { $0.id == category.id }!
        let updatedTask1 = updatedCategory.tasks.first { $0.id == task1.id }!
        let updatedTask2 = updatedCategory.tasks.first { $0.id == task2.id }!
        
        XCTAssertEqual(updatedTask1.claimedBy, user1.id)
        XCTAssertEqual(updatedTask2.claimedBy, user2.id)
    }
    
    func testLeaderboardUpdatesAfterTaskCompletion() {
        let user = appState.users.first!
        appState.selectUser(user)
        
        let leaderboardBefore = appState.getLeaderboard()
        let userRankBefore = leaderboardBefore.first { $0.userId == user.id }!.rank
        
        // Complete multiple high-value tasks
        for category in appState.choreCategories {
            if let task = category.tasks.first(where: { $0.isAvailable && $0.points >= 20 }) {
                appState.completeTask(task, in: category.id)
            }
        }
        
        let leaderboardAfter = appState.getLeaderboard()
        let userRankAfter = leaderboardAfter.first { $0.userId == user.id }!.rank
        
        XCTAssertLessThanOrEqual(userRankAfter, userRankBefore, "Rank should improve or stay same")
    }
}
