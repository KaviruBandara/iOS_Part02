//
//  UserModelTests.swift
//  HouseHarmonyTests
//
//  Unit tests for UserModel
//

import XCTest
@testable import HouseHarmony

final class UserModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testUserModelInitialization() {
        let user = UserModel(
            name: "Test User",
            avatar: "TestAvatar",
            colorTheme: "#FF0000"
        )
        
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.avatar, "TestAvatar")
        XCTAssertEqual(user.colorTheme, "#FF0000")
        XCTAssertEqual(user.totalPoints, 0)
        XCTAssertEqual(user.currentStreak, 0)
        XCTAssertEqual(user.longestStreak, 0)
        XCTAssertEqual(user.tasksCompleted, 0)
        XCTAssertTrue(user.badgesEarned.isEmpty)
        XCTAssertFalse(user.isAdmin)
    }
    
    func testUserModelWithCustomValues() {
        let user = UserModel(
            name: "Admin User",
            avatar: "AdminAvatar",
            colorTheme: "#00FF00",
            totalPoints: 500,
            currentStreak: 10,
            longestStreak: 15,
            tasksCompleted: 50,
            badgesEarned: ["badge1", "badge2"],
            isAdmin: true
        )
        
        XCTAssertEqual(user.totalPoints, 500)
        XCTAssertEqual(user.currentStreak, 10)
        XCTAssertEqual(user.longestStreak, 15)
        XCTAssertEqual(user.tasksCompleted, 50)
        XCTAssertEqual(user.badgesEarned.count, 2)
        XCTAssertTrue(user.isAdmin)
    }
    
    // MARK: - Level Calculation Tests
    
    func testLevelCalculationAtZeroPoints() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 0
        )
        
        XCTAssertEqual(user.level, 1, "User with 0 points should be level 1")
    }
    
    func testLevelCalculationAt99Points() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 99
        )
        
        XCTAssertEqual(user.level, 1, "User with 99 points should be level 1")
    }
    
    func testLevelCalculationAt100Points() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 100
        )
        
        XCTAssertEqual(user.level, 2, "User with 100 points should be level 2")
    }
    
    func testLevelCalculationAt450Points() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 450
        )
        
        XCTAssertEqual(user.level, 5, "User with 450 points should be level 5")
    }
    
    func testLevelCalculationAt1000Points() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 1000
        )
        
        XCTAssertEqual(user.level, 11, "User with 1000 points should be level 11")
    }
    
    // MARK: - Progress to Next Level Tests
    
    func testProgressToNextLevelAtZeroPoints() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 0
        )
        
        XCTAssertEqual(user.progressToNextLevel, 0.0, accuracy: 0.01)
    }
    
    func testProgressToNextLevelAt50Points() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 50
        )
        
        XCTAssertEqual(user.progressToNextLevel, 0.5, accuracy: 0.01, "50 points should be 50% to level 2")
    }
    
    func testProgressToNextLevelAt150Points() {
        let user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            totalPoints: 150
        )
        
        XCTAssertEqual(user.progressToNextLevel, 0.5, accuracy: 0.01, "150 points should be 50% to level 3")
    }
    
    // MARK: - Points Management Tests
    
    func testAddPoints() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        user.addPoints(50)
        XCTAssertEqual(user.totalPoints, 50)
        
        user.addPoints(30)
        XCTAssertEqual(user.totalPoints, 80)
    }
    
    func testAddMultiplePoints() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        user.addPoints(10)
        user.addPoints(20)
        user.addPoints(30)
        
        XCTAssertEqual(user.totalPoints, 60)
    }
    
    // MARK: - Task Count Tests
    
    func testIncrementTaskCount() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        XCTAssertEqual(user.tasksCompleted, 0)
        
        user.incrementTaskCount()
        XCTAssertEqual(user.tasksCompleted, 1)
        
        user.incrementTaskCount()
        XCTAssertEqual(user.tasksCompleted, 2)
    }
    
    // MARK: - Streak Management Tests
    
    func testUpdateStreakIncrement() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        user.updateStreak(increment: true)
        XCTAssertEqual(user.currentStreak, 1)
        XCTAssertEqual(user.longestStreak, 1)
        
        user.updateStreak(increment: true)
        XCTAssertEqual(user.currentStreak, 2)
        XCTAssertEqual(user.longestStreak, 2)
    }
    
    func testUpdateStreakReset() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000",
            currentStreak: 5,
            longestStreak: 5
        )
        
        user.updateStreak(increment: false)
        XCTAssertEqual(user.currentStreak, 0)
        XCTAssertEqual(user.longestStreak, 5, "Longest streak should not change on reset")
    }
    
    func testLongestStreakTracking() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        // Build up to 5
        for _ in 1...5 {
            user.updateStreak(increment: true)
        }
        XCTAssertEqual(user.currentStreak, 5)
        XCTAssertEqual(user.longestStreak, 5)
        
        // Reset
        user.updateStreak(increment: false)
        XCTAssertEqual(user.currentStreak, 0)
        XCTAssertEqual(user.longestStreak, 5)
        
        // Build up to 3 (should not update longest)
        for _ in 1...3 {
            user.updateStreak(increment: true)
        }
        XCTAssertEqual(user.currentStreak, 3)
        XCTAssertEqual(user.longestStreak, 5)
        
        // Build up to 7 (should update longest)
        for _ in 4...7 {
            user.updateStreak(increment: true)
        }
        XCTAssertEqual(user.currentStreak, 7)
        XCTAssertEqual(user.longestStreak, 7)
    }
    
    // MARK: - Badge Management Tests
    
    func testEarnBadge() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        XCTAssertTrue(user.badgesEarned.isEmpty)
        
        user.earnBadge("first_task")
        XCTAssertEqual(user.badgesEarned.count, 1)
        XCTAssertTrue(user.badgesEarned.contains("first_task"))
    }
    
    func testEarnMultipleBadges() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        user.earnBadge("badge1")
        user.earnBadge("badge2")
        user.earnBadge("badge3")
        
        XCTAssertEqual(user.badgesEarned.count, 3)
        XCTAssertTrue(user.badgesEarned.contains("badge1"))
        XCTAssertTrue(user.badgesEarned.contains("badge2"))
        XCTAssertTrue(user.badgesEarned.contains("badge3"))
    }
    
    func testEarnDuplicateBadge() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        user.earnBadge("first_task")
        user.earnBadge("first_task")
        user.earnBadge("first_task")
        
        XCTAssertEqual(user.badgesEarned.count, 1, "Should not add duplicate badges")
    }
    
    // MARK: - Last Active Tests
    
    func testUpdateLastActive() {
        var user = UserModel(
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        let originalDate = user.lastActive
        
        // Wait a tiny bit
        Thread.sleep(forTimeInterval: 0.01)
        
        user.updateLastActive()
        
        XCTAssertTrue(user.lastActive > originalDate, "Last active should be updated to a later time")
    }
    
    // MARK: - Sample Data Tests
    
    func testSampleDataExists() {
        XCTAssertFalse(UserModel.samples.isEmpty, "Sample data should exist")
        XCTAssertEqual(UserModel.samples.count, 4, "Should have 4 sample users")
    }
    
    func testSampleDataHasValidUsers() {
        for user in UserModel.samples {
            XCTAssertFalse(user.name.isEmpty, "User name should not be empty")
            XCTAssertFalse(user.avatar.isEmpty, "User avatar should not be empty")
            XCTAssertFalse(user.colorTheme.isEmpty, "User color theme should not be empty")
            XCTAssertGreaterThanOrEqual(user.totalPoints, 0, "Points should be non-negative")
            XCTAssertGreaterThanOrEqual(user.currentStreak, 0, "Streak should be non-negative")
        }
    }
    
    func testSampleDataHasAdmins() {
        let admins = UserModel.samples.filter { $0.isAdmin }
        XCTAssertGreaterThan(admins.count, 0, "Should have at least one admin in sample data")
    }
    
    // MARK: - Codable Tests
    
    func testUserModelEncodable() throws {
        let user = UserModel(
            name: "Test User",
            avatar: "TestAvatar",
            colorTheme: "#FF0000",
            totalPoints: 100,
            currentStreak: 5
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        
        XCTAssertFalse(data.isEmpty, "Encoded data should not be empty")
    }
    
    func testUserModelDecodable() throws {
        let user = UserModel(
            name: "Test User",
            avatar: "TestAvatar",
            colorTheme: "#FF0000",
            totalPoints: 100,
            currentStreak: 5,
            badgesEarned: ["badge1", "badge2"]
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(user)
        
        let decoder = JSONDecoder()
        let decodedUser = try decoder.decode(UserModel.self, from: data)
        
        XCTAssertEqual(decodedUser.name, user.name)
        XCTAssertEqual(decodedUser.avatar, user.avatar)
        XCTAssertEqual(decodedUser.colorTheme, user.colorTheme)
        XCTAssertEqual(decodedUser.totalPoints, user.totalPoints)
        XCTAssertEqual(decodedUser.currentStreak, user.currentStreak)
        XCTAssertEqual(decodedUser.badgesEarned, user.badgesEarned)
    }
    
    // MARK: - Equatable Tests
    
    func testUserModelEquality() {
        let id = UUID()
        let user1 = UserModel(
            id: id,
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        let user2 = UserModel(
            id: id,
            name: "Test",
            avatar: "Test",
            colorTheme: "#000000"
        )
        
        XCTAssertEqual(user1, user2, "Users with same ID and properties should be equal")
    }
    
    func testUserModelInequality() {
        let user1 = UserModel(
            name: "Test1",
            avatar: "Test1",
            colorTheme: "#000000"
        )
        let user2 = UserModel(
            name: "Test2",
            avatar: "Test2",
            colorTheme: "#000000"
        )
        
        XCTAssertNotEqual(user1, user2, "Users with different IDs should not be equal")
    }
}
