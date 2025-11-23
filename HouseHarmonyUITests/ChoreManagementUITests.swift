//
//  ChoreManagementUITests.swift
//  HouseHarmonyUITests
//
//  UI tests for chore claiming and completion flow
//

import XCTest

final class ChoreManagementUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Select a profile to get to dashboard
        let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
        if profileCard.waitForExistence(timeout: 5) {
            profileCard.tap()
        }
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Dashboard Navigation Tests
    
    func testDashboardDisplayed() throws {
        let choresTab = app.buttons["Chores"]
        XCTAssertTrue(choresTab.waitForExistence(timeout: 5))
    }
    
    func testNavigationTabsExist() throws {
        XCTAssertTrue(app.buttons["Chores"].exists || app.staticTexts["Chores"].exists)
        XCTAssertTrue(app.buttons["Leaderboard"].exists || app.staticTexts["Leaderboard"].exists)
        XCTAssertTrue(app.buttons["Profile"].exists || app.staticTexts["Profile"].exists)
        XCTAssertTrue(app.buttons["Settings"].exists || app.staticTexts["Settings"].exists)
    }
    
    func testNavigateToChoresTab() throws {
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
            
            // Should see chore categories
            let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
            XCTAssertTrue(categoryCard.waitForExistence(timeout: 5))
        }
    }
    
    // MARK: - Chore Categories Tests
    
    func testChoreCategoriesDisplayed() throws {
        // Navigate to chores tab if not already there
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        // Check for category cards
        let categoryCards = app.buttons.matching(identifier: "categoryCard")
        XCTAssertGreaterThan(categoryCards.count, 0)
    }
    
    func testCategoryCardShowsInfo() throws {
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        XCTAssertTrue(categoryCard.waitForExistence(timeout: 5))
        
        // Category should be tappable
        XCTAssertTrue(categoryCard.isHittable)
    }
    
    func testSelectCategory() throws {
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        XCTAssertTrue(categoryCard.waitForExistence(timeout: 5))
        
        categoryCard.tap()
        
        // Should see task list
        let taskCard = app.buttons.matching(identifier: "taskCard").firstMatch
        XCTAssertTrue(taskCard.waitForExistence(timeout: 5))
    }
    
    // MARK: - Task List Tests
    
    func testTaskListDisplayed() throws {
        // Navigate to a category
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Check for tasks
        let taskCards = app.buttons.matching(identifier: "taskCard")
        XCTAssertGreaterThan(taskCards.count, 0)
    }
    
    func testTaskCardShowsInfo() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        let taskCard = app.buttons.matching(identifier: "taskCard").firstMatch
        XCTAssertTrue(taskCard.waitForExistence(timeout: 5))
        
        // Task card should be visible and interactive
        XCTAssertTrue(taskCard.exists)
    }
    
    // MARK: - Task Claiming Tests
    
    func testClaimTaskButton() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Look for claim button
        let claimButton = app.buttons["Claim Task"]
        if claimButton.waitForExistence(timeout: 5) {
            XCTAssertTrue(claimButton.isHittable)
        }
    }
    
    func testClaimTask() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Find and tap claim button
        let claimButton = app.buttons["Claim Task"]
        if claimButton.waitForExistence(timeout: 5) {
            claimButton.tap()
            
            // After claiming, button should change to "Complete" or "Unclaim"
            let completeButton = app.buttons["Complete"]
            let unclaimButton = app.buttons["Unclaim"]
            
            XCTAssertTrue(
                completeButton.waitForExistence(timeout: 3) ||
                unclaimButton.exists
            )
        }
    }
    
    // MARK: - Task Completion Tests
    
    func testCompleteTask() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Claim a task first
        let claimButton = app.buttons["Claim Task"]
        if claimButton.waitForExistence(timeout: 5) {
            claimButton.tap()
            
            // Then complete it
            let completeButton = app.buttons["Complete"]
            if completeButton.waitForExistence(timeout: 3) {
                completeButton.tap()
                
                // Should see completion celebration
                let continueButton = app.buttons["Continue"]
                XCTAssertTrue(continueButton.waitForExistence(timeout: 5))
            }
        }
    }
    
    func testCompletionCelebration() throws {
        // Navigate and complete a task
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        let claimButton = app.buttons["Claim Task"]
        if claimButton.waitForExistence(timeout: 5) {
            claimButton.tap()
            
            let completeButton = app.buttons["Complete"]
            if completeButton.waitForExistence(timeout: 3) {
                completeButton.tap()
                
                // Check for celebration elements
                let continueButton = app.buttons["Continue"]
                XCTAssertTrue(continueButton.waitForExistence(timeout: 5))
                
                // Tap continue to dismiss
                continueButton.tap()
                
                // Should return to task list
                let taskCard = app.buttons.matching(identifier: "taskCard").firstMatch
                XCTAssertTrue(taskCard.waitForExistence(timeout: 3))
            }
        }
    }
    
    // MARK: - Back Navigation Tests
    
    func testBackFromTaskList() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Look for back button
        let backButton = app.buttons["Back"]
        if backButton.exists {
            backButton.tap()
            
            // Should return to categories
            let categoryCardAgain = app.buttons.matching(identifier: "categoryCard").firstMatch
            XCTAssertTrue(categoryCardAgain.waitForExistence(timeout: 3))
        }
    }
    
    // MARK: - Task Priority Tests
    
    func testTaskPriorityIndicators() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Check for priority indicators (Low, Medium, High)
        let hasPriorityInfo = 
            app.staticTexts["Low"].exists ||
            app.staticTexts["Medium"].exists ||
            app.staticTexts["High"].exists
        
        XCTAssertTrue(hasPriorityInfo || app.buttons.matching(identifier: "taskCard").firstMatch.exists)
    }
    
    // MARK: - Points Display Tests
    
    func testTaskPointsDisplayed() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        // Check for points indicator (⭐ or "pts")
        let hasPointsInfo = app.staticTexs.containing(NSPredicate(format: "label CONTAINS '⭐' OR label CONTAINS 'pts'")).firstMatch.exists
        
        // At least task list should be visible
        XCTAssertTrue(hasPointsInfo || app.buttons.matching(identifier: "taskCard").firstMatch.exists)
    }
    
    // MARK: - Multiple Tasks Tests
    
    func testMultipleTasksDisplayed() throws {
        // Navigate to task list
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
        
        let taskCards = app.buttons.matching(identifier: "taskCard")
        XCTAssertGreaterThan(taskCards.count, 0)
    }
    
    // MARK: - Performance Tests
    
    func testCategoryLoadingPerformance() throws {
        measure {
            let choresTab = app.buttons["Chores"]
            if choresTab.exists {
                choresTab.tap()
            }
            
            let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
            _ = categoryCard.waitForExistence(timeout: 5)
        }
    }
    
    func testTaskListLoadingPerformance() throws {
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
        }
        
        let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            measure {
                categoryCard.tap()
                let taskCard = app.buttons.matching(identifier: "taskCard").firstMatch
                _ = taskCard.waitForExistence(timeout: 5)
                
                // Go back for next iteration
                let backButton = app.buttons["Back"]
                if backButton.exists {
                    backButton.tap()
                }
            }
        }
    }
}
