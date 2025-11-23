//
//  UITestHelpers.swift
//  HouseHarmonyUITests
//
//  Helper functions for UI testing
//

import XCTest

// MARK: - UI Test Extensions

extension XCUIApplication {
    
    /// Launch app and select first profile
    func launchAndSelectProfile() {
        self.launch()
        
        let profileCard = self.buttons.matching(identifier: "profileCard").firstMatch
        if profileCard.waitForExistence(timeout: 5) {
            profileCard.tap()
        }
    }
    
    /// Navigate to a specific tab
    func navigateToTab(_ tabName: String) {
        let tab = self.buttons[tabName]
        if tab.waitForExistence(timeout: 5) {
            tab.tap()
        }
    }
    
    /// Navigate to chores tab and select first category
    func navigateToFirstCategory() {
        navigateToTab("Chores")
        
        let categoryCard = self.buttons.matching(identifier: "categoryCard").firstMatch
        if categoryCard.waitForExistence(timeout: 5) {
            categoryCard.tap()
        }
    }
    
    /// Complete a task flow (claim and complete)
    func completeFirstAvailableTask() -> Bool {
        navigateToFirstCategory()
        
        let claimButton = self.buttons["Claim Task"]
        guard claimButton.waitForExistence(timeout: 5) else {
            return false
        }
        
        claimButton.tap()
        
        let completeButton = self.buttons["Complete"]
        guard completeButton.waitForExistence(timeout: 3) else {
            return false
        }
        
        completeButton.tap()
        
        let continueButton = self.buttons["Continue"]
        if continueButton.waitForExistence(timeout: 5) {
            continueButton.tap()
            return true
        }
        
        return false
    }
    
    /// Go back using back button
    func goBack() {
        let backButton = self.buttons["Back"]
        if backButton.exists {
            backButton.tap()
        }
    }
}

extension XCUIElement {
    
    /// Check if element has focus (tvOS specific)
    var hasFocus: Bool {
        return self.value(forKey: "hasKeyboardFocus") as? Bool ?? false
    }
    
    /// Wait for element to exist and be hittable
    func waitForHittable(timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == true AND hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    /// Tap element with retry
    func tapWithRetry(maxAttempts: Int = 3) {
        var attempts = 0
        while attempts < maxAttempts {
            if self.isHittable {
                self.tap()
                return
            }
            attempts += 1
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
}

// MARK: - UI Test Helpers

struct UITestHelpers {
    
    // MARK: - Element Finding
    
    static func findElement(
        in app: XCUIApplication,
        withIdentifier identifier: String,
        timeout: TimeInterval = 5
    ) -> XCUIElement? {
        let element = app.buttons[identifier]
        return element.waitForExistence(timeout: timeout) ? element : nil
    }
    
    static func findStaticText(
        in app: XCUIApplication,
        containing text: String,
        timeout: TimeInterval = 5
    ) -> XCUIElement? {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        let element = app.staticTexts.containing(predicate).firstMatch
        return element.waitForExistence(timeout: timeout) ? element : nil
    }
    
    // MARK: - Wait Helpers
    
    static func waitForElementToDisappear(
        _ element: XCUIElement,
        timeout: TimeInterval = 5
    ) -> Bool {
        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    static func waitForAnyElement(
        _ elements: [XCUIElement],
        timeout: TimeInterval = 5
    ) -> XCUIElement? {
        let startTime = Date()
        while Date().timeIntervalSince(startTime) < timeout {
            for element in elements {
                if element.exists {
                    return element
                }
            }
            Thread.sleep(forTimeInterval: 0.1)
        }
        return nil
    }
    
    // MARK: - Navigation Helpers
    
    static func navigateToProfileSelection(app: XCUIApplication) {
        // Navigate to settings
        app.navigateToTab("Settings")
        
        // Tap switch profile
        let switchProfileButton = app.buttons["Switch Profile"]
        if switchProfileButton.waitForExistence(timeout: 5) {
            switchProfileButton.tap()
        }
    }
    
    static func logout(app: XCUIApplication) {
        navigateToProfileSelection(app: app)
    }
    
    // MARK: - Assertion Helpers
    
    static func assertTabExists(
        _ tabName: String,
        in app: XCUIApplication,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let tab = app.buttons[tabName]
        XCTAssertTrue(
            tab.exists,
            "Tab '\(tabName)' should exist",
            file: file,
            line: line
        )
    }
    
    static func assertElementContainsText(
        _ element: XCUIElement,
        text: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let label = element.label
        XCTAssertTrue(
            label.contains(text),
            "Element should contain '\(text)', but got '\(label)'",
            file: file,
            line: line
        )
    }
    
    // MARK: - Screenshot Helpers
    
    static func takeScreenshot(
        named name: String,
        app: XCUIApplication
    ) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        XCTContext.runActivity(named: "Screenshot: \(name)") { activity in
            activity.add(attachment)
        }
    }
    
    // MARK: - Cleanup Helpers
    
    static func resetAppState(app: XCUIApplication) {
        // Navigate to settings
        app.navigateToTab("Settings")
        
        // Look for reset button
        let resetButton = app.buttons["Reset All Data"]
        if resetButton.waitForExistence(timeout: 5) {
            resetButton.tap()
            
            // Confirm if needed
            let confirmButton = app.buttons["Confirm"]
            if confirmButton.waitForExistence(timeout: 2) {
                confirmButton.tap()
            }
        }
    }
}

// MARK: - Test Constants

enum UITestConstants {
    static let defaultTimeout: TimeInterval = 5.0
    static let shortTimeout: TimeInterval = 2.0
    static let longTimeout: TimeInterval = 10.0
    
    static let tabNames = ["Chores", "Leaderboard", "Profile", "Settings"]
    
    static let sampleUserNames = ["Alex", "Sarah", "Mike", "Emma"]
    
    static let categoryNames = [
        "Kitchen",
        "Bathroom",
        "Living Room",
        "Bedroom",
        "Laundry",
        "Outdoor"
    ]
}

// MARK: - Accessibility Identifiers

enum AccessibilityIdentifiers {
    // Profile Selection
    static let profileCard = "profileCard"
    static let addUserCard = "addUserCard"
    
    // Dashboard
    static let categoryCard = "categoryCard"
    static let taskCard = "taskCard"
    static let leaderboardRow = "leaderboardRow"
    
    // Buttons
    static let claimButton = "Claim Task"
    static let completeButton = "Complete"
    static let continueButton = "Continue"
    static let backButton = "Back"
    
    // Tabs
    static let choresTab = "Chores"
    static let leaderboardTab = "Leaderboard"
    static let profileTab = "Profile"
    static let settingsTab = "Settings"
}

// MARK: - Test Data

struct TestData {
    static let testUser = (
        name: "Test User",
        avatar: "👤",
        color: "#FF0000"
    )
    
    static let testTask = (
        title: "Test Task",
        description: "Test Description",
        points: 10,
        category: "Kitchen"
    )
}

// MARK: - Performance Measurement

extension XCTestCase {
    
    func measureUIPerformance(
        name: String,
        block: () -> Void
    ) {
        let options = XCTMeasureOptions()
        options.iterationCount = 5
        
        measure(metrics: [XCTClockMetric()], options: options) {
            block()
        }
    }
    
    func measureAppLaunchTime(app: XCUIApplication) {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
