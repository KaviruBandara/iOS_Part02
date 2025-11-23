//
//  TestHelpers.swift
//  HouseHarmonyTests
//
//  Helper functions and utilities for testing
//

import Foundation
@testable import HouseHarmony

// MARK: - Mock Data Helpers

struct TestHelpers {
    
    // MARK: - User Creation Helpers
    
    static func createTestUser(
        name: String = "Test User",
        points: Int = 0,
        streak: Int = 0,
        tasksCompleted: Int = 0,
        isAdmin: Bool = false
    ) -> UserModel {
        return UserModel(
            name: name,
            avatar: "TestAvatar",
            colorTheme: "#FF0000",
            totalPoints: points,
            currentStreak: streak,
            longestStreak: streak,
            tasksCompleted: tasksCompleted,
            isAdmin: isAdmin
        )
    }
    
    static func createTestUsers(count: Int) -> [UserModel] {
        var users: [UserModel] = []
        for i in 0..<count {
            users.append(createTestUser(
                name: "User \(i + 1)",
                points: (count - i) * 100 // Descending points
            ))
        }
        return users
    }
    
    // MARK: - Task Creation Helpers
    
    static func createTestTask(
        title: String = "Test Task",
        category: String = "Kitchen",
        points: Int = 10,
        priority: TaskPriority = .medium,
        isCompleted: Bool = false,
        claimedBy: UUID? = nil
    ) -> TaskModel {
        return TaskModel(
            title: title,
            description: "Test description",
            points: points,
            category: category,
            priority: priority,
            isCompleted: isCompleted,
            claimedBy: claimedBy
        )
    }
    
    static func createTestTasks(count: Int, category: String = "Kitchen") -> [TaskModel] {
        var tasks: [TaskModel] = []
        let priorities: [TaskPriority] = [.low, .medium, .high]
        
        for i in 0..<count {
            tasks.append(createTestTask(
                title: "Task \(i + 1)",
                category: category,
                points: priorities[i % 3].points,
                priority: priorities[i % 3]
            ))
        }
        return tasks
    }
    
    // MARK: - Badge Helpers
    
    static func createUserWithBadges(badgeIds: [String]) -> UserModel {
        return UserModel(
            name: "Badge User",
            avatar: "BadgeAvatar",
            colorTheme: "#00FF00",
            badgesEarned: badgeIds
        )
    }
    
    // MARK: - Leaderboard Helpers
    
    static func createLeaderboardEntry(
        rank: Int,
        name: String = "Test User",
        points: Int = 100
    ) -> LeaderboardEntry {
        let user = createTestUser(name: name, points: points)
        return LeaderboardEntry(from: user, rank: rank)
    }
    
    // MARK: - Date Helpers
    
    static func dateFromDaysAgo(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
    
    static func dateFromHoursAgo(_ hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: -hours, to: Date()) ?? Date()
    }
    
    // MARK: - Comparison Helpers
    
    static func assertDatesEqual(_ date1: Date, _ date2: Date, accuracy: TimeInterval = 1.0) -> Bool {
        return abs(date1.timeIntervalSince(date2)) <= accuracy
    }
    
    // MARK: - Random Data Helpers
    
    static func randomColorHex() -> String {
        let colors = ["#FF6B6B", "#4ECDC4", "#FFD93D", "#A8E6CF", "#95E1D3", "#F38181"]
        return colors.randomElement() ?? "#FF6B6B"
    }
    
    static func randomAvatar() -> String {
        let avatars = ["👨", "👩", "👦", "👧", "🧑", "👴", "👵"]
        return avatars.randomElement() ?? "👤"
    }
    
    static func randomTaskCategory() -> String {
        let categories = ["Kitchen", "Bathroom", "Living Room", "Bedroom", "Laundry", "Outdoor"]
        return categories.randomElement() ?? "Kitchen"
    }
}

// MARK: - XCTest Extensions

import XCTest

extension XCTestCase {
    
    /// Wait for a condition to be true with timeout
    func waitFor(
        timeout: TimeInterval = 5.0,
        condition: () -> Bool
    ) -> Bool {
        let startTime = Date()
        while Date().timeIntervalSince(startTime) < timeout {
            if condition() {
                return true
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        }
        return false
    }
    
    /// Assert that two arrays contain the same elements (order doesn't matter)
    func assertArraysEqual<T: Equatable>(_ array1: [T], _ array2: [T], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(Set(array1), Set(array2), "Arrays should contain the same elements", file: file, line: line)
    }
    
    /// Assert that a value is within a range
    func assertInRange<T: Comparable>(_ value: T, min: T, max: T, file: StaticString = #file, line: UInt = #line) {
        XCTAssertGreaterThanOrEqual(value, min, "Value should be >= \(min)", file: file, line: line)
        XCTAssertLessThanOrEqual(value, max, "Value should be <= \(max)", file: file, line: line)
    }
}

// MARK: - Mock Persistence Service

class MockPersistenceService {
    var users: [UserModel] = []
    var choreCategories: [ChoreCategory] = []
    
    var saveUsersCalled = false
    var saveChoreCategoriesCalled = false
    var loadUsersCalled = false
    var loadChoreCategoriesCalled = false
    
    func saveUsers(_ users: [UserModel]) {
        self.users = users
        saveUsersCalled = true
    }
    
    func loadUsers() -> [UserModel] {
        loadUsersCalled = true
        return users
    }
    
    func saveChoreCategories(_ categories: [ChoreCategory]) {
        self.choreCategories = categories
        saveChoreCategoriesCalled = true
    }
    
    func loadChoreCategories() -> [ChoreCategory] {
        loadChoreCategoriesCalled = true
        return choreCategories
    }
    
    func reset() {
        users = []
        choreCategories = []
        saveUsersCalled = false
        saveChoreCategoriesCalled = false
        loadUsersCalled = false
        loadChoreCategoriesCalled = false
    }
}

// MARK: - Test Constants

enum TestConstants {
    static let defaultTimeout: TimeInterval = 5.0
    static let shortTimeout: TimeInterval = 1.0
    static let longTimeout: TimeInterval = 10.0
    
    static let sampleUserNames = ["Alex", "Sarah", "Mike", "Emma"]
    static let sampleCategories = ["Kitchen", "Bathroom", "Living Room", "Bedroom", "Laundry", "Outdoor"]
    
    static let badgeIds = [
        "first_task",
        "tasks_10",
        "tasks_25",
        "tasks_50",
        "tasks_100",
        "streak_3",
        "streak_7",
        "streak_14",
        "streak_21",
        "streak_30",
        "points_100",
        "points_500",
        "points_1000"
    ]
}

// MARK: - Performance Testing Helpers

extension XCTestCase {
    
    /// Measure the time it takes to execute a block
    func measureTime(block: () -> Void) -> TimeInterval {
        let startTime = Date()
        block()
        return Date().timeIntervalSince(startTime)
    }
    
    /// Assert that a block executes within a time limit
    func assertExecutesWithin(
        _ timeLimit: TimeInterval,
        block: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let executionTime = measureTime(block: block)
        XCTAssertLessThan(
            executionTime,
            timeLimit,
            "Execution took \(executionTime)s, expected < \(timeLimit)s",
            file: file,
            line: line
        )
    }
}
