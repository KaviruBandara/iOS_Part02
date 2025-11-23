//
//  TaskModelTests.swift
//  HouseHarmonyTests
//
//  Unit tests for TaskModel
//

import XCTest
@testable import HouseHarmony

final class TaskModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testTaskModelInitialization() {
        let task = TaskModel(
            title: "Test Task",
            category: "Kitchen"
        )
        
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.category, "Kitchen")
        XCTAssertEqual(task.description, "")
        XCTAssertEqual(task.points, 10)
        XCTAssertEqual(task.priority, .medium)
        XCTAssertEqual(task.frequency, .daily)
        XCTAssertFalse(task.isCompleted)
        XCTAssertNil(task.completedBy)
        XCTAssertNil(task.claimedBy)
    }
    
    func testTaskModelWithCustomValues() {
        let userId = UUID()
        let task = TaskModel(
            title: "Custom Task",
            description: "Custom description",
            points: 25,
            category: "Bathroom",
            priority: .high,
            frequency: .weekly,
            isCompleted: true,
            completedBy: userId
        )
        
        XCTAssertEqual(task.title, "Custom Task")
        XCTAssertEqual(task.description, "Custom description")
        XCTAssertEqual(task.points, 25)
        XCTAssertEqual(task.category, "Bathroom")
        XCTAssertEqual(task.priority, .high)
        XCTAssertEqual(task.frequency, .weekly)
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.completedBy, userId)
    }
    
    // MARK: - Priority Tests
    
    func testLowPriorityPoints() {
        let priority = TaskPriority.low
        XCTAssertEqual(priority.points, 5)
    }
    
    func testMediumPriorityPoints() {
        let priority = TaskPriority.medium
        XCTAssertEqual(priority.points, 10)
    }
    
    func testHighPriorityPoints() {
        let priority = TaskPriority.high
        XCTAssertEqual(priority.points, 20)
    }
    
    // MARK: - Frequency Tests
    
    func testTaskFrequencyRawValues() {
        XCTAssertEqual(TaskFrequency.daily.rawValue, "Daily")
        XCTAssertEqual(TaskFrequency.weekly.rawValue, "Weekly")
        XCTAssertEqual(TaskFrequency.monthly.rawValue, "Monthly")
        XCTAssertEqual(TaskFrequency.oneTime.rawValue, "One Time")
    }
    
    // MARK: - Status Tests
    
    func testIsClaimedWhenNotClaimed() {
        let task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        XCTAssertFalse(task.isClaimed)
    }
    
    func testIsClaimedWhenClaimed() {
        let userId = UUID()
        let task = TaskModel(
            title: "Test",
            category: "Kitchen",
            claimedBy: userId
        )
        
        XCTAssertTrue(task.isClaimed)
    }
    
    func testIsAvailableWhenNotClaimedOrCompleted() {
        let task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        XCTAssertTrue(task.isAvailable)
    }
    
    func testIsNotAvailableWhenClaimed() {
        let userId = UUID()
        let task = TaskModel(
            title: "Test",
            category: "Kitchen",
            claimedBy: userId
        )
        
        XCTAssertFalse(task.isAvailable)
    }
    
    func testIsNotAvailableWhenCompleted() {
        let task = TaskModel(
            title: "Test",
            category: "Kitchen",
            isCompleted: true
        )
        
        XCTAssertFalse(task.isAvailable)
    }
    
    // MARK: - Claim Tests
    
    func testClaimTask() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        let userId = UUID()
        task.claim(by: userId)
        
        XCTAssertTrue(task.isClaimed)
        XCTAssertEqual(task.claimedBy, userId)
        XCTAssertNotNil(task.claimedAt)
    }
    
    func testClaimTaskSetsTimestamp() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        let beforeClaim = Date()
        task.claim(by: UUID())
        let afterClaim = Date()
        
        XCTAssertNotNil(task.claimedAt)
        XCTAssertTrue(task.claimedAt! >= beforeClaim)
        XCTAssertTrue(task.claimedAt! <= afterClaim)
    }
    
    // MARK: - Complete Tests
    
    func testCompleteTask() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        let userId = UUID()
        task.complete(by: userId)
        
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.completedBy, userId)
        XCTAssertNotNil(task.completedAt)
    }
    
    func testCompleteTaskSetsTimestamp() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        let beforeComplete = Date()
        task.complete(by: UUID())
        let afterComplete = Date()
        
        XCTAssertNotNil(task.completedAt)
        XCTAssertTrue(task.completedAt! >= beforeComplete)
        XCTAssertTrue(task.completedAt! <= afterComplete)
    }
    
    // MARK: - Unclaim Tests
    
    func testUnclaimTask() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen",
            claimedBy: UUID(),
            claimedAt: Date()
        )
        
        XCTAssertTrue(task.isClaimed)
        
        task.unclaim()
        
        XCTAssertFalse(task.isClaimed)
        XCTAssertNil(task.claimedBy)
        XCTAssertNil(task.claimedAt)
    }
    
    // MARK: - Reset Tests
    
    func testResetTask() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen",
            isCompleted: true,
            completedBy: UUID(),
            completedAt: Date(),
            claimedBy: UUID(),
            claimedAt: Date()
        )
        
        XCTAssertTrue(task.isCompleted)
        XCTAssertTrue(task.isClaimed)
        
        task.reset()
        
        XCTAssertFalse(task.isCompleted)
        XCTAssertFalse(task.isClaimed)
        XCTAssertNil(task.completedBy)
        XCTAssertNil(task.completedAt)
        XCTAssertNil(task.claimedBy)
        XCTAssertNil(task.claimedAt)
    }
    
    // MARK: - Task Lifecycle Tests
    
    func testCompleteTaskLifecycle() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        // Initially available
        XCTAssertTrue(task.isAvailable)
        XCTAssertFalse(task.isClaimed)
        XCTAssertFalse(task.isCompleted)
        
        // Claim the task
        let userId = UUID()
        task.claim(by: userId)
        XCTAssertFalse(task.isAvailable)
        XCTAssertTrue(task.isClaimed)
        XCTAssertFalse(task.isCompleted)
        
        // Complete the task
        task.complete(by: userId)
        XCTAssertFalse(task.isAvailable)
        XCTAssertTrue(task.isClaimed)
        XCTAssertTrue(task.isCompleted)
        
        // Reset the task
        task.reset()
        XCTAssertTrue(task.isAvailable)
        XCTAssertFalse(task.isClaimed)
        XCTAssertFalse(task.isCompleted)
    }
    
    // MARK: - Sample Data Tests
    
    func testSampleDataExists() {
        XCTAssertFalse(TaskModel.samples.isEmpty, "Sample data should exist")
        XCTAssertGreaterThan(TaskModel.samples.count, 0, "Should have sample tasks")
    }
    
    func testSampleDataHasValidTasks() {
        for task in TaskModel.samples {
            XCTAssertFalse(task.title.isEmpty, "Task title should not be empty")
            XCTAssertFalse(task.category.isEmpty, "Task category should not be empty")
            XCTAssertGreaterThan(task.points, 0, "Task points should be positive")
        }
    }
    
    func testSampleDataHasVariedPriorities() {
        let priorities = Set(TaskModel.samples.map { $0.priority })
        XCTAssertGreaterThan(priorities.count, 1, "Sample data should have varied priorities")
    }
    
    // MARK: - Codable Tests
    
    func testTaskModelEncodable() throws {
        let task = TaskModel(
            title: "Test Task",
            description: "Test description",
            points: 15,
            category: "Kitchen",
            priority: .high,
            frequency: .daily
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(task)
        
        XCTAssertFalse(data.isEmpty, "Encoded data should not be empty")
    }
    
    func testTaskModelDecodable() throws {
        let task = TaskModel(
            title: "Test Task",
            description: "Test description",
            points: 15,
            category: "Kitchen",
            priority: .high,
            frequency: .weekly
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(task)
        
        let decoder = JSONDecoder()
        let decodedTask = try decoder.decode(TaskModel.self, from: data)
        
        XCTAssertEqual(decodedTask.title, task.title)
        XCTAssertEqual(decodedTask.description, task.description)
        XCTAssertEqual(decodedTask.points, task.points)
        XCTAssertEqual(decodedTask.category, task.category)
        XCTAssertEqual(decodedTask.priority, task.priority)
        XCTAssertEqual(decodedTask.frequency, task.frequency)
    }
    
    // MARK: - Equatable Tests
    
    func testTaskModelEquality() {
        let id = UUID()
        let task1 = TaskModel(
            id: id,
            title: "Test",
            category: "Kitchen"
        )
        let task2 = TaskModel(
            id: id,
            title: "Test",
            category: "Kitchen"
        )
        
        XCTAssertEqual(task1, task2, "Tasks with same ID and properties should be equal")
    }
    
    func testTaskModelInequality() {
        let task1 = TaskModel(
            title: "Test1",
            category: "Kitchen"
        )
        let task2 = TaskModel(
            title: "Test2",
            category: "Kitchen"
        )
        
        XCTAssertNotEqual(task1, task2, "Tasks with different IDs should not be equal")
    }
    
    // MARK: - Edge Case Tests
    
    func testCompleteUnclaimedTask() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        let userId = UUID()
        task.complete(by: userId)
        
        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.completedBy, userId)
        XCTAssertNil(task.claimedBy, "Task was never claimed")
    }
    
    func testMultipleClaimsOverwrite() {
        var task = TaskModel(
            title: "Test",
            category: "Kitchen"
        )
        
        let user1 = UUID()
        let user2 = UUID()
        
        task.claim(by: user1)
        let firstClaimTime = task.claimedAt
        
        Thread.sleep(forTimeInterval: 0.01)
        
        task.claim(by: user2)
        
        XCTAssertEqual(task.claimedBy, user2, "Second claim should overwrite first")
        XCTAssertNotEqual(task.claimedAt, firstClaimTime, "Claim time should be updated")
    }
    
    func testResetPreservesTaskMetadata() {
        var task = TaskModel(
            title: "Test Task",
            description: "Test description",
            points: 25,
            category: "Kitchen",
            priority: .high,
            frequency: .weekly,
            isCompleted: true,
            completedBy: UUID()
        )
        
        task.reset()
        
        // Metadata should be preserved
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.description, "Test description")
        XCTAssertEqual(task.points, 25)
        XCTAssertEqual(task.category, "Kitchen")
        XCTAssertEqual(task.priority, .high)
        XCTAssertEqual(task.frequency, .weekly)
        
        // Status should be reset
        XCTAssertFalse(task.isCompleted)
        XCTAssertNil(task.completedBy)
    }
}
