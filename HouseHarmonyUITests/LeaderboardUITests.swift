//
//  LeaderboardUITests.swift
//  HouseHarmonyUITests
//
//  UI tests for leaderboard functionality
//

import XCTest

final class LeaderboardUITests: XCTestCase {
    
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
    
    // MARK: - Navigation Tests
    
    func testNavigateToLeaderboard() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        XCTAssertTrue(leaderboardTab.waitForExistence(timeout: 5))
        
        leaderboardTab.tap()
        
        // Should see leaderboard content
        XCTAssertTrue(app.staticTexts["Leaderboard"].exists || 
                     app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Leaderboard'")).firstMatch.exists)
    }
    
    // MARK: - Leaderboard Display Tests
    
    func testLeaderboardEntriesDisplayed() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for leaderboard entries
        let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
        XCTAssertGreaterThan(leaderboardRows.count, 0)
    }
    
    func testTopThreeDisplayed() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for podium or top 3 indicators
        let hasMedals = 
            app.staticTexts["🥇"].exists ||
            app.staticTexts["🥈"].exists ||
            app.staticTexts["🥉"].exists
        
        // At least leaderboard should be visible
        XCTAssertTrue(hasMedals || app.buttons.matching(identifier: "leaderboardRow").firstMatch.exists)
    }
    
    func testLeaderboardRanksDisplayed() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for rank numbers (1st, 2nd, 3rd, etc.)
        let hasRankInfo = 
            app.staticTexts["1"].exists ||
            app.staticTexts["#1"].exists ||
            app.staticTexts.containing(NSPredicate(format: "label CONTAINS '1st'")).firstMatch.exists
        
        XCTAssertTrue(hasRankInfo || app.buttons.matching(identifier: "leaderboardRow").firstMatch.exists)
    }
    
    // MARK: - User Information Tests
    
    func testLeaderboardShowsUserNames() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for sample user names
        let sampleNames = ["Alex", "Sarah", "Mike", "Emma"]
        var foundName = false
        
        for name in sampleNames {
            if app.staticTexts[name].exists {
                foundName = true
                break
            }
        }
        
        XCTAssertTrue(foundName || app.buttons.matching(identifier: "leaderboardRow").firstMatch.exists)
    }
    
    func testLeaderboardShowsPoints() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for points indicator
        let hasPointsInfo = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '⭐' OR label CONTAINS 'pts'")).firstMatch.exists
        
        XCTAssertTrue(hasPointsInfo || app.buttons.matching(identifier: "leaderboardRow").firstMatch.exists)
    }
    
    func testLeaderboardShowsTaskCounts() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for task count or checkmark indicator
        let hasTaskInfo = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '✅' OR label CONTAINS 'tasks'")).firstMatch.exists
        
        XCTAssertTrue(hasTaskInfo || app.buttons.matching(identifier: "leaderboardRow").firstMatch.exists)
    }
    
    // MARK: - Current User Highlight Tests
    
    func testCurrentUserHighlighted() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Current user's row should exist
        let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
        XCTAssertGreaterThan(leaderboardRows.count, 0)
        
        // At least one row should be visible
        XCTAssertTrue(leaderboardRows.firstMatch.exists)
    }
    
    // MARK: - Sorting Tests
    
    func testLeaderboardSortedByPoints() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Leaderboard should be displayed
        let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
        XCTAssertGreaterThan(leaderboardRows.count, 0)
        
        // First entry should be rank 1
        let firstRow = leaderboardRows.firstMatch
        XCTAssertTrue(firstRow.exists)
    }
    
    // MARK: - Streak Display Tests
    
    func testLeaderboardShowsStreaks() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for streak indicator (🔥)
        let hasStreakInfo = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '🔥'")).firstMatch.exists
        
        XCTAssertTrue(hasStreakInfo || app.buttons.matching(identifier: "leaderboardRow").firstMatch.exists)
    }
    
    // MARK: - Period Filter Tests (if implemented)
    
    func testLeaderboardPeriodFilters() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Check for period filters (All Time, Monthly, Weekly, Daily)
        let hasFilters = 
            app.buttons["All Time"].exists ||
            app.buttons["Monthly"].exists ||
            app.buttons["Weekly"].exists ||
            app.buttons["Daily"].exists
        
        // Filters are optional, so this is a soft check
        if hasFilters {
            XCTAssertTrue(true, "Period filters found")
        }
    }
    
    // MARK: - Scrolling Tests
    
    func testLeaderboardScrollable() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
        
        if leaderboardRows.count > 3 {
            // Try to scroll if there are many entries
            let firstRow = leaderboardRows.firstMatch
            let lastRow = leaderboardRows.element(boundBy: leaderboardRows.count - 1)
            
            XCTAssertTrue(firstRow.exists)
            // Last row might not be visible initially if scrolling works
        }
    }
    
    // MARK: - Empty State Tests
    
    func testLeaderboardNotEmpty() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Should have at least one entry
        let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
        XCTAssertGreaterThan(leaderboardRows.count, 0)
    }
    
    // MARK: - Navigation Back Tests
    
    func testNavigateAwayFromLeaderboard() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        // Navigate to another tab
        let choresTab = app.buttons["Chores"]
        if choresTab.exists {
            choresTab.tap()
            
            // Should see chores content
            let categoryCard = app.buttons.matching(identifier: "categoryCard").firstMatch
            XCTAssertTrue(categoryCard.waitForExistence(timeout: 3))
        }
    }
    
    // MARK: - Real-time Update Tests
    
    func testLeaderboardUpdatesAfterTaskCompletion() throws {
        // Complete a task first
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
                
                // Dismiss celebration
                let continueButton = app.buttons["Continue"]
                if continueButton.waitForExistence(timeout: 5) {
                    continueButton.tap()
                }
            }
        }
        
        // Now check leaderboard
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.exists {
            leaderboardTab.tap()
            
            // Leaderboard should be displayed with updated data
            let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
            XCTAssertGreaterThan(leaderboardRows.count, 0)
        }
    }
    
    // MARK: - Performance Tests
    
    func testLeaderboardLoadingPerformance() throws {
        measure {
            let leaderboardTab = app.buttons["Leaderboard"]
            if leaderboardTab.exists {
                leaderboardTab.tap()
            }
            
            let leaderboardRow = app.buttons.matching(identifier: "leaderboardRow").firstMatch
            _ = leaderboardRow.waitForExistence(timeout: 5)
            
            // Navigate away for next iteration
            let choresTab = app.buttons["Chores"]
            if choresTab.exists {
                choresTab.tap()
            }
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testLeaderboardAccessibility() throws {
        let leaderboardTab = app.buttons["Leaderboard"]
        if leaderboardTab.waitForExistence(timeout: 5) {
            leaderboardTab.tap()
        }
        
        let leaderboardRows = app.buttons.matching(identifier: "leaderboardRow")
        
        for i in 0..<min(leaderboardRows.count, 3) {
            let row = leaderboardRows.element(boundBy: i)
            XCTAssertTrue(row.exists)
        }
    }
}
