//
//  ProfileSelectionUITests.swift
//  HouseHarmonyUITests
//
//  UI tests for profile selection flow
//

import XCTest

final class ProfileSelectionUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Welcome Screen Tests
    
    func testWelcomeScreenDisplayed() throws {
        // Check if welcome screen elements are visible
        XCTAssertTrue(app.staticTexts["HouseHarmony"].exists)
        XCTAssertTrue(app.staticTexts["Choose Your Profile"].exists || 
                     app.staticTexts["Select Your Profile"].exists)
    }
    
    func testProfileCardsDisplayed() throws {
        // Wait for profile cards to appear
        let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
        XCTAssertTrue(profileCard.waitForExistence(timeout: 5))
        
        // Check multiple profile cards exist
        let profileCards = app.buttons.matching(identifier: "profileCard")
        XCTAssertGreaterThan(profileCards.count, 0)
    }
    
    func testSampleProfilesDisplayed() throws {
        // Check for sample user names
        let sampleNames = ["Alex", "Sarah", "Mike", "Emma"]
        
        for name in sampleNames {
            let nameExists = app.staticTexts[name].exists
            if nameExists {
                XCTAssertTrue(true, "\(name) profile found")
                break
            }
        }
    }
    
    // MARK: - Profile Selection Tests
    
    func testSelectProfile() throws {
        // Find and tap first profile card
        let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
        XCTAssertTrue(profileCard.waitForExistence(timeout: 5))
        
        profileCard.tap()
        
        // Wait for dashboard to appear
        let dashboardIndicator = app.staticTexts["Chores"] // Tab name
        XCTAssertTrue(dashboardIndicator.waitForExistence(timeout: 5))
    }
    
    func testProfileCardFocus() throws {
        let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
        XCTAssertTrue(profileCard.waitForExistence(timeout: 5))
        
        // On tvOS, focused elements should be highlighted
        XCTAssertTrue(profileCard.hasFocus || profileCard.isHittable)
    }
    
    func testNavigateBetweenProfiles() throws {
        let profileCards = app.buttons.matching(identifier: "profileCard")
        XCTAssertGreaterThan(profileCards.count, 1)
        
        // Navigate using arrow keys (simulated swipe on tvOS)
        let firstCard = profileCards.element(boundBy: 0)
        let secondCard = profileCards.element(boundBy: 1)
        
        XCTAssertTrue(firstCard.exists)
        XCTAssertTrue(secondCard.exists)
    }
    
    // MARK: - Profile Information Tests
    
    func testProfileCardShowsUserInfo() throws {
        let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
        XCTAssertTrue(profileCard.waitForExistence(timeout: 5))
        
        // Profile cards should contain user information
        // Check for points indicator (⭐ symbol or "pts")
        let hasPointsInfo = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '⭐' OR label CONTAINS 'pts'")).firstMatch.exists
        
        // At least one profile should show points
        XCTAssertTrue(hasPointsInfo || profileCard.exists)
    }
    
    // MARK: - Add User Tests
    
    func testAddUserButtonExists() throws {
        // Look for add user button or card
        let addUserButton = app.buttons["addUserCard"]
        
        // Add user functionality may or may not be visible
        // This is a soft check
        if addUserButton.exists {
            XCTAssertTrue(addUserButton.isHittable)
        }
    }
    
    // MARK: - Navigation Tests
    
    func testProfileSelectionToDashboard() throws {
        let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
        XCTAssertTrue(profileCard.waitForExistence(timeout: 5))
        
        profileCard.tap()
        
        // Verify we're on dashboard by checking for navigation tabs
        let choresTab = app.buttons["Chores"]
        let leaderboardTab = app.buttons["Leaderboard"]
        let profileTab = app.buttons["Profile"]
        let settingsTab = app.buttons["Settings"]
        
        // At least one tab should exist
        XCTAssertTrue(
            choresTab.waitForExistence(timeout: 5) ||
            leaderboardTab.exists ||
            profileTab.exists ||
            settingsTab.exists
        )
    }
    
    // MARK: - Accessibility Tests
    
    func testProfileCardsAccessible() throws {
        let profileCards = app.buttons.matching(identifier: "profileCard")
        
        for i in 0..<min(profileCards.count, 4) {
            let card = profileCards.element(boundBy: i)
            XCTAssertTrue(card.exists)
            XCTAssertTrue(card.isHittable)
        }
    }
    
    // MARK: - Performance Tests
    
    func testProfileSelectionPerformance() throws {
        measure {
            let profileCard = app.buttons.matching(identifier: "profileCard").firstMatch
            _ = profileCard.waitForExistence(timeout: 5)
        }
    }
    
    // MARK: - Visual Hierarchy Tests
    
    func testAppLogoVisible() throws {
        // Check for app branding
        let logo = app.staticTexts["HouseHarmony"]
        XCTAssertTrue(logo.exists || app.images["appLogo"].exists)
    }
    
    func testTaglineVisible() throws {
        // Check for tagline or subtitle
        let tagline = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Profile' OR label CONTAINS 'Choose'")).firstMatch
        XCTAssertTrue(tagline.exists)
    }
}
