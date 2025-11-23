# 🧪 HouseHarmony Testing Guide

Complete guide for running and writing tests for the HouseHarmony tvOS application.

---

## Table of Contents

1. [Overview](#overview)
2. [Test Structure](#test-structure)
3. [Running Tests](#running-tests)
4. [Unit Tests](#unit-tests)
5. [UI Tests](#ui-tests)
6. [Test Coverage](#test-coverage)
7. [Writing New Tests](#writing-new-tests)
8. [Continuous Integration](#continuous-integration)
9. [Troubleshooting](#troubleshooting)

---

## Overview

HouseHarmony includes comprehensive test coverage:

- **Unit Tests**: Test models, view models, and business logic
- **UI Tests**: Test user flows and interface interactions
- **Test Helpers**: Utilities for creating test data and assertions

### Test Targets

- `HouseHarmonyTests`: Unit tests
- `HouseHarmonyUITests`: UI/Integration tests

---

## Test Structure

```
HouseHarmony/
├── HouseHarmonyTests/
│   ├── UserModelTests.swift          # User model unit tests
│   ├── TaskModelTests.swift          # Task model unit tests
│   ├── AppStateTests.swift           # AppState ViewModel tests
│   └── TestHelpers.swift             # Test utilities
│
└── HouseHarmonyUITests/
    ├── ProfileSelectionUITests.swift # Profile selection flow
    ├── ChoreManagementUITests.swift  # Chore claiming/completion
    ├── LeaderboardUITests.swift      # Leaderboard functionality
    └── UITestHelpers.swift           # UI test utilities
```

---

## Running Tests

### Using Xcode

#### Run All Tests
1. Open `HouseHarmony.xcodeproj` in Xcode
2. Press `⌘ + U` (Command + U)
3. Or: **Product** → **Test**

#### Run Specific Test Suite
1. Open the Test Navigator (`⌘ + 6`)
2. Click the ▶️ button next to the test suite name

#### Run Single Test
1. Open the test file
2. Click the ◆ icon in the gutter next to the test method
3. Or: Place cursor in test method and press `⌘ + U`

### Using Command Line

#### Run All Tests
```bash
cd /path/to/HouseHarmony
xcodebuild test \
  -project HouseHarmony.xcodeproj \
  -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest'
```

#### Run Only Unit Tests
```bash
xcodebuild test \
  -project HouseHarmony.xcodeproj \
  -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -only-testing:HouseHarmonyTests
```

#### Run Only UI Tests
```bash
xcodebuild test \
  -project HouseHarmony.xcodeproj \
  -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -only-testing:HouseHarmonyUITests
```

#### Run Specific Test Class
```bash
xcodebuild test \
  -project HouseHarmony.xcodeproj \
  -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -only-testing:HouseHarmonyTests/UserModelTests
```

---

## Unit Tests

### UserModelTests

Tests the `UserModel` including:
- Initialization
- Level calculation (100 points = 1 level)
- Progress to next level
- Points management
- Streak tracking
- Badge earning
- Codable conformance

**Example Test:**
```swift
func testLevelCalculationAt450Points() {
    let user = UserModel(
        name: "Test",
        avatar: "Test",
        colorTheme: "#000000",
        totalPoints: 450
    )
    
    XCTAssertEqual(user.level, 5)
}
```

### TaskModelTests

Tests the `TaskModel` including:
- Task creation
- Priority and points
- Claiming tasks
- Completing tasks
- Task lifecycle
- Reset functionality

**Example Test:**
```swift
func testCompleteTaskLifecycle() {
    var task = TaskModel(title: "Test", category: "Kitchen")
    
    // Initially available
    XCTAssertTrue(task.isAvailable)
    
    // Claim the task
    task.claim(by: userId)
    XCTAssertTrue(task.isClaimed)
    
    // Complete the task
    task.complete(by: userId)
    XCTAssertTrue(task.isCompleted)
}
```

### AppStateTests

Tests the `AppState` ViewModel including:
- User selection and logout
- Task claiming and completion
- Badge awarding logic
- Leaderboard generation
- Data persistence

**Example Test:**
```swift
func testCompleteTask() {
    appState.selectUser(user)
    appState.completeTask(task, in: categoryId)
    
    let updatedUser = appState.users.first { $0.id == user.id }!
    XCTAssertEqual(updatedUser.totalPoints, initialPoints + taskPoints)
}
```

### Test Helpers

Utility functions for creating test data:

```swift
// Create test user
let user = TestHelpers.createTestUser(
    name: "Test User",
    points: 100,
    streak: 5
)

// Create test tasks
let tasks = TestHelpers.createTestTasks(count: 5, category: "Kitchen")

// Create leaderboard entry
let entry = TestHelpers.createLeaderboardEntry(rank: 1, points: 500)
```

---

## UI Tests

### ProfileSelectionUITests

Tests profile selection flow:
- Welcome screen display
- Profile cards visibility
- Profile selection
- Navigation to dashboard

**Key Tests:**
- `testWelcomeScreenDisplayed()`
- `testSelectProfile()`
- `testNavigateBetweenProfiles()`

### ChoreManagementUITests

Tests chore management:
- Category browsing
- Task list display
- Task claiming
- Task completion
- Completion celebration

**Key Tests:**
- `testSelectCategory()`
- `testClaimTask()`
- `testCompleteTask()`
- `testCompletionCelebration()`

### LeaderboardUITests

Tests leaderboard functionality:
- Leaderboard display
- Ranking order
- User information
- Real-time updates

**Key Tests:**
- `testLeaderboardSortedByPoints()`
- `testTopThreeDisplayed()`
- `testLeaderboardUpdatesAfterTaskCompletion()`

### UI Test Helpers

Utility functions for UI testing:

```swift
// Launch and select profile
app.launchAndSelectProfile()

// Navigate to tab
app.navigateToTab("Chores")

// Complete a task
let success = app.completeFirstAvailableTask()

// Take screenshot
UITestHelpers.takeScreenshot(named: "Dashboard", app: app)
```

---

## Test Coverage

### Current Coverage

- **Models**: ~95% coverage
  - UserModel: Full coverage
  - TaskModel: Full coverage
  - Badge logic: Covered in AppState

- **ViewModels**: ~85% coverage
  - AppState: Core functionality covered
  - Badge awarding: Fully tested
  - Leaderboard: Fully tested

- **UI Flows**: ~70% coverage
  - Profile selection: Covered
  - Task management: Covered
  - Leaderboard: Covered
  - Settings: Partial coverage

### Viewing Coverage

1. Run tests with coverage enabled:
   - **Product** → **Test** (⌘ + U)
2. Open Report Navigator (`⌘ + 9`)
3. Select latest test run
4. Click **Coverage** tab
5. View coverage percentages by file

### Command Line Coverage

```bash
xcodebuild test \
  -project HouseHarmony.xcodeproj \
  -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -enableCodeCoverage YES \
  -resultBundlePath TestResults.xcresult
```

View results:
```bash
xcrun xccov view --report TestResults.xcresult
```

---

## Writing New Tests

### Unit Test Template

```swift
import XCTest
@testable import HouseHarmony

final class MyFeatureTests: XCTestCase {
    
    var sut: MyFeature! // System Under Test
    
    override func setUp() {
        super.setUp()
        sut = MyFeature()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFeatureBehavior() {
        // Given
        let input = "test"
        
        // When
        let result = sut.process(input)
        
        // Then
        XCTAssertEqual(result, "expected")
    }
}
```

### UI Test Template

```swift
import XCTest

final class MyFeatureUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testUserFlow() throws {
        // Navigate to feature
        app.navigateToTab("MyFeature")
        
        // Interact with UI
        let button = app.buttons["MyButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()
        
        // Verify result
        let result = app.staticTexts["Result"]
        XCTAssertTrue(result.exists)
    }
}
```

### Best Practices

#### Unit Tests
- ✅ Test one thing per test
- ✅ Use descriptive test names
- ✅ Follow Given-When-Then pattern
- ✅ Use test helpers for setup
- ✅ Test edge cases
- ❌ Don't test implementation details
- ❌ Don't make tests dependent on each other

#### UI Tests
- ✅ Use accessibility identifiers
- ✅ Wait for elements to exist
- ✅ Test complete user flows
- ✅ Use helper methods for common actions
- ✅ Take screenshots on failures
- ❌ Don't hardcode wait times
- ❌ Don't test too many things in one test

### Naming Conventions

```swift
// Unit tests: test + WhatIsBeingTested + ExpectedBehavior
func testUserLevel_With450Points_ReturnsLevel5()
func testTaskClaim_ByUser_SetsClaimedBy()

// UI tests: test + UserAction + ExpectedResult
func testSelectProfile_NavigatesToDashboard()
func testCompleteTask_ShowsCelebration()
```

---

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/tests.yml`:

```yaml
name: Run Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode.app
    
    - name: Run Unit Tests
      run: |
        xcodebuild test \
          -project HouseHarmony.xcodeproj \
          -scheme HouseHarmony \
          -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
          -only-testing:HouseHarmonyTests \
          -enableCodeCoverage YES
    
    - name: Run UI Tests
      run: |
        xcodebuild test \
          -project HouseHarmony.xcodeproj \
          -scheme HouseHarmony \
          -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
          -only-testing:HouseHarmonyUITests
```

---

## Troubleshooting

### Common Issues

#### Tests Not Running

**Problem**: Tests don't execute when pressing ⌘ + U

**Solutions:**
1. Clean build folder: **Product** → **Clean Build Folder** (⌘ + Shift + K)
2. Reset simulator: `xcrun simctl erase all`
3. Restart Xcode
4. Check scheme settings: **Product** → **Scheme** → **Edit Scheme** → **Test**

#### UI Tests Failing

**Problem**: UI tests fail with "element not found"

**Solutions:**
1. Increase timeout values
2. Add accessibility identifiers to views
3. Check if element is hittable: `element.isHittable`
4. Wait for element: `element.waitForExistence(timeout: 5)`
5. Take screenshots to debug: `UITestHelpers.takeScreenshot()`

#### Simulator Issues

**Problem**: Simulator not responding or tests hanging

**Solutions:**
```bash
# Kill all simulators
killall Simulator

# Erase all simulators
xcrun simctl erase all

# Reset simulator content and settings
xcrun simctl shutdown all
```

#### Code Coverage Not Showing

**Problem**: Coverage data not appearing

**Solutions:**
1. Enable coverage in scheme:
   - **Product** → **Scheme** → **Edit Scheme**
   - Select **Test**
   - Check **Gather coverage for**
   - Select targets to cover
2. Run tests again
3. Check Report Navigator (⌘ + 9)

### Performance Issues

If tests are slow:

1. **Run tests in parallel**:
   - Edit scheme → Test → Options
   - Check "Execute in parallel"

2. **Disable animations** (UI tests):
```swift
override func setUp() {
    super.setUp()
    app.launchArguments += ["-UITestingDisableAnimations"]
}
```

3. **Use mock data** instead of real persistence

---

## Test Maintenance

### Regular Tasks

- ✅ Run full test suite before commits
- ✅ Update tests when adding features
- ✅ Remove obsolete tests
- ✅ Keep test coverage above 80%
- ✅ Review failing tests immediately
- ✅ Update test documentation

### Code Review Checklist

- [ ] New features have tests
- [ ] Tests are passing
- [ ] Coverage hasn't decreased
- [ ] Tests follow naming conventions
- [ ] No hardcoded values
- [ ] Proper use of test helpers

---

## Resources

### XCTest Documentation
- [Apple XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [UI Testing Guide](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/)

### Best Practices
- [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Given-When-Then](https://martinfowler.com/bliki/GivenWhenThen.html)

---

## Quick Reference

### Run Commands

```bash
# All tests
⌘ + U

# Specific test
Click ◆ in gutter

# Last failed tests
⌘ + Control + Option + U

# Test without building
⌘ + Control + U
```

### Assertions

```swift
// Equality
XCTAssertEqual(actual, expected)
XCTAssertNotEqual(actual, unexpected)

// Boolean
XCTAssertTrue(condition)
XCTAssertFalse(condition)

// Nil
XCTAssertNil(value)
XCTAssertNotNil(value)

// Comparison
XCTAssertGreaterThan(value, minimum)
XCTAssertLessThan(value, maximum)

// Throws
XCTAssertThrowsError(try expression())
XCTAssertNoThrow(try expression())
```

---

**Happy Testing! 🧪✨**

*For questions or issues, see the main README.md or open an issue.*
