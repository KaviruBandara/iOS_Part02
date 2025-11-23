# 🛠️ HouseHarmony Development Guide

**For Developers and Contributors**

---

## Table of Contents
1. [Development Setup](#development-setup)
2. [Project Structure](#project-structure)
3. [Coding Standards](#coding-standards)
4. [Adding Features](#adding-features)
5. [Testing Guidelines](#testing-guidelines)
6. [Performance Optimization](#performance-optimization)
7. [Deployment](#deployment)
8. [Common Tasks](#common-tasks)
9. [Troubleshooting](#troubleshooting)

---

## Development Setup

### Prerequisites

- **macOS**: Ventura (13.0) or later
- **Xcode**: 15.0 or later
- **tvOS SDK**: 17.0 or later
- **Swift**: 5.9 or later
- **Git**: For version control

### Initial Setup

```bash
# Clone the repository
git clone <repository-url>
cd HouseHarmony

# Open in Xcode
open HouseHarmony.xcodeproj

# Or use Xcode command line tools
xed .
```

### Xcode Configuration

1. **Select Scheme**: HouseHarmony (tvOS)
2. **Select Destination**: Apple TV simulator
3. **Build**: Cmd + B
4. **Run**: Cmd + R

### Simulator Setup

**Recommended Simulators:**
- Apple TV 4K (3rd generation) - tvOS 17.0
- Apple TV 4K (2nd generation) - tvOS 17.0

**Simulator Settings:**
- **Window → Show Device Bezels**: On (for realistic view)
- **Debug → Slow Animations**: Off (unless debugging)

### Hardware Testing

**Physical Apple TV Setup:**
1. Enable Developer Mode on Apple TV
2. Connect to same network as Mac
3. Xcode → Window → Devices and Simulators
4. Select your Apple TV
5. Run project on device

---

## Project Structure

### Directory Overview

```
HouseHarmony/
│
├── HouseHarmony/                   # Main app target
│   ├── Models/                     # Data models
│   │   ├── UserModel.swift
│   │   ├── TaskModel.swift
│   │   ├── ChoreModel.swift
│   │   ├── BadgeModel.swift
│   │   └── LeaderboardEntry.swift
│   │
│   ├── ViewModels/                 # Business logic
│   │   └── AppState.swift
│   │
│   ├── Screens/                    # Full-screen views
│   │   ├── ProfileSelectionScreen.swift
│   │   ├── DashboardScreen.swift
│   │   ├── ChoresScreen.swift
│   │   ├── TaskCompletionView.swift
│   │   ├── LeaderboardScreen.swift
│   │   ├── ProfileStatsScreen.swift
│   │   └── SettingsScreen.swift
│   │
│   ├── Components/                 # Reusable UI components
│   │   ├── FocusableCard.swift
│   │   ├── AvatarView.swift
│   │   ├── ProgressRing.swift
│   │   ├── BadgeChip.swift
│   │   ├── ConfettiView.swift
│   │   ├── LeaderboardRow.swift
│   │   └── TaskCard.swift
│   │
│   ├── Services/                   # Data services
│   │   └── PersistenceService.swift
│   │
│   ├── Utils/                      # Helpers and extensions
│   │   ├── ColorExtension.swift
│   │   └── AnimationHelpers.swift
│   │
│   ├── Assets.xcassets/            # Images and colors
│   │
│   ├── HouseHarmonyApp.swift       # App entry point
│   └── ContentView.swift           # Root view
│
├── HouseHarmony.xcodeproj/         # Xcode project
│
├── README.md                       # User documentation
├── ARCHITECTURE.md                 # Architecture details
├── USER_GUIDE.md                   # End-user guide
└── DEVELOPMENT.md                  # This file
```

### File Naming Conventions

- **Models**: `[Name]Model.swift` (e.g., `UserModel.swift`)
- **ViewModels**: `[Name]ViewModel.swift` or descriptive (e.g., `AppState.swift`)
- **Screens**: `[Name]Screen.swift` (e.g., `DashboardScreen.swift`)
- **Components**: `[Name]View.swift` or `[Name].swift` (e.g., `AvatarView.swift`)
- **Services**: `[Name]Service.swift` (e.g., `PersistenceService.swift`)
- **Extensions**: `[Type]Extension.swift` (e.g., `ColorExtension.swift`)

---

## Coding Standards

### Swift Style Guide

**Follow Apple's Swift conventions:**

```swift
// MARK: - Good Practices

// 1. Clear, descriptive names
func completeTask(_ task: TaskModel, in categoryId: UUID) { }

// 2. Use type inference when obvious
let user = UserModel(name: "Alex", ...)  // ✅
let user: UserModel = UserModel(...)     // ❌ redundant

// 3. Prefer structs over classes (when possible)
struct UserModel: Identifiable { }  // ✅

// 4. Use access control
private func helperMethod() { }
public struct PublicModel { }

// 5. Document public APIs
/// Completes a task and awards points to the user
/// - Parameters:
///   - task: The task to complete
///   - categoryId: The category containing the task
func completeTask(_ task: TaskModel, in categoryId: UUID) { }
```

### SwiftUI Best Practices

```swift
// 1. Extract subviews for clarity
var body: some View {
    VStack {
        HeaderView()      // ✅ Extracted
        ContentView()
        FooterView()
    }
}

// 2. Use @ViewBuilder for conditional views
@ViewBuilder
func makeContent() -> some View {
    if condition {
        ViewA()
    } else {
        ViewB()
    }
}

// 3. Prefer computed properties for simple views
var headerView: some View {
    Text("Header")
        .font(.title)
}

// 4. Use modifiers efficiently
Text("Hello")
    .font(.title)
    .foregroundColor(.white)
    .padding()
```

### Code Organization

**Within Files:**

```swift
// MARK: - Type Definition
struct MyView: View { }

// MARK: - Properties
@State private var property

// MARK: - Body
var body: some View { }

// MARK: - Subviews
var headerView: some View { }

// MARK: - Methods
func helperMethod() { }

// MARK: - Preview
#Preview { }
```

### Comments

```swift
// Single-line comments for brief explanations
let points = 10  // Points awarded for this task

/// Multi-line documentation for public APIs
/// - Parameter task: The task to process
/// - Returns: Updated task with completion data
func process(task: TaskModel) -> TaskModel { }

// MARK: - Section headers for organization
// MARK: Initialization
// MARK: Public Methods
// MARK: Private Helpers
```

---

## Adding Features

### Adding a New Model

1. **Create file**: `Models/NewModel.swift`
2. **Define struct**:
```swift
struct NewModel: Identifiable, Codable, Equatable {
    let id: UUID
    var property: String
    
    init(id: UUID = UUID(), property: String) {
        self.id = id
        self.property = property
    }
}

// MARK: - Sample Data
extension NewModel {
    static let samples: [NewModel] = [
        NewModel(property: "Sample 1"),
        NewModel(property: "Sample 2")
    ]
}
```
3. **Add to AppState** if needed
4. **Add persistence** if needed

### Adding a New Screen

1. **Create file**: `Screens/NewScreen.swift`
2. **Define view**:
```swift
import SwiftUI

struct NewScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var localState: String = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1A2E")
                .ignoresSafeArea()
            
            VStack {
                // Your content
            }
        }
    }
}

#Preview {
    NewScreen()
        .environmentObject(AppState())
}
```
3. **Add navigation** in appropriate parent view
4. **Test in simulator**

### Adding a New Component

1. **Create file**: `Components/NewComponent.swift`
2. **Define reusable component**:
```swift
struct NewComponent: View {
    let property: String
    var optionalProperty: Bool = true
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Text(property)
            .focusScale()
    }
}

#Preview {
    NewComponent(property: "Test")
        .padding()
}
```
3. **Use in screens**: Import and use
4. **Add to preview** for testing

### Adding a New Badge

1. **Open**: `Models/BadgeModel.swift`
2. **Add to `allBadges` array**:
```swift
BadgeModel(
    id: "unique_id",
    name: "Badge Name",
    description: "How to unlock",
    icon: "sf.symbol.name",
    type: .milestone,  // or .streak, .category, .special
    requirement: 10,
    colorHex: "#FF6B6B"
)
```
3. **Add unlock logic** in `AppState.checkAndAwardBadges()`
4. **Test unlocking** the badge

---

## Testing Guidelines

### Manual Testing Checklist

**Before Each Commit:**
- [ ] App builds without errors
- [ ] App runs on simulator
- [ ] No crashes during basic flow
- [ ] Navigation works correctly
- [ ] Focus system works on all screens

**Before Each Release:**
- [ ] Test all user flows
- [ ] Test on multiple simulators
- [ ] Test on physical device (if possible)
- [ ] Verify data persistence
- [ ] Check all animations
- [ ] Verify all badge unlocks
- [ ] Test edge cases (0 points, max points, etc.)

### Unit Testing (Future)

**Create test target:**
```swift
import XCTest
@testable import HouseHarmony

class UserModelTests: XCTestCase {
    func testPointsCalculation() {
        var user = UserModel(name: "Test", avatar: "👤", colorTheme: "#000000")
        user.addPoints(100)
        XCTAssertEqual(user.totalPoints, 100)
        XCTAssertEqual(user.level, 2)
    }
}
```

### UI Testing (Future)

```swift
func testTaskCompletion() {
    let app = XCUIApplication()
    app.launch()
    
    // Select profile
    app.buttons["Alex"].tap()
    
    // Navigate to chores
    app.buttons["Chores"].tap()
    
    // Select category
    app.buttons["Kitchen"].tap()
    
    // Complete task
    app.buttons["Claim Task"].tap()
    app.buttons["Complete"].tap()
    
    // Verify celebration appears
    XCTAssert(app.staticTexts["Task Completed!"].exists)
}
```

---

## Performance Optimization

### Profiling

**Instruments:**
1. Product → Profile (Cmd + I)
2. Select "Time Profiler"
3. Record while using app
4. Identify bottlenecks

**Common Issues:**
- Heavy view body computations
- Unnecessary re-renders
- Large image assets
- Complex animations

### Optimization Techniques

**1. Lazy Loading**
```swift
// Use LazyVStack/LazyVGrid for long lists
LazyVStack {
    ForEach(items) { item in
        ItemView(item: item)
    }
}
```

**2. Computed Property Caching**
```swift
// Cache expensive computations
private var cachedLeaderboard: [LeaderboardEntry]?

func getLeaderboard() -> [LeaderboardEntry] {
    if let cached = cachedLeaderboard {
        return cached
    }
    let result = calculateLeaderboard()
    cachedLeaderboard = result
    return result
}
```

**3. Reduce Animation Complexity**
```swift
// Prefer simple transforms
.scaleEffect(isFocused ? 1.05 : 1.0)  // ✅ Fast

// Avoid complex animations
.rotationEffect(...)
.offset(...)
.blur(...)  // ❌ Can be slow
```

**4. Asset Optimization**
- Use vector graphics (PDF) when possible
- Compress images
- Use appropriate sizes
- Lazy load if needed

---

## Deployment

### Building for Distribution

1. **Set Version**: Project → General → Version
2. **Archive**: Product → Archive
3. **Export**: Organizer → Distribute App
4. **TestFlight**: Upload to App Store Connect
5. **App Store**: Submit for review

### App Store Assets

**Required:**
- App Icon (1280x768 for tvOS)
- Screenshots (1920x1080)
- App Description
- Keywords
- Privacy Policy
- Support URL

### Version Numbering

**Semantic Versioning:**
- **Major.Minor.Patch** (e.g., 1.2.3)
- **Major**: Breaking changes
- **Minor**: New features
- **Patch**: Bug fixes

---

## Common Tasks

### Changing Sample Data

**Edit**: `Models/[Model]Model.swift`
```swift
extension UserModel {
    static let samples: [UserModel] = [
        // Add/modify users here
    ]
}
```

### Changing Colors

**Edit**: `Utils/ColorExtension.swift`
```swift
extension Color {
    static let appBackground = Color(hex: "#YOUR_COLOR")
}
```

### Adding New Category

**Edit**: `Models/ChoreModel.swift`
```swift
ChoreCategory(
    name: "New Category",
    icon: "new.icon",
    colorHex: "#COLOR",
    tasks: [
        TaskModel(title: "Task 1", points: 10, category: "New Category")
    ]
)
```

### Modifying Point Values

**Edit**: `Models/TaskModel.swift`
```swift
enum TaskPriority: String, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var points: Int {
        switch self {
        case .low: return 5      // Change here
        case .medium: return 10
        case .high: return 20
        }
    }
}
```

### Changing Level Requirements

**Edit**: `Models/UserModel.swift`
```swift
var level: Int {
    return (totalPoints / 100) + 1  // Change 100 to different value
}
```

---

## Troubleshooting

### Build Errors

**"Cannot find type in scope"**
- Check import statements
- Verify file is in target membership
- Clean build folder (Cmd + Shift + K)

**"Expected declaration"**
- Check for syntax errors
- Verify closing braces
- Look for typos in keywords

### Runtime Errors

**"Fatal error: No ObservableObject"**
- Ensure `.environmentObject(appState)` is set
- Check AppState initialization
- Verify @EnvironmentObject declarations

**"Index out of range"**
- Check array bounds before accessing
- Use optional binding: `if let item = array.first { }`

### Simulator Issues

**Slow Performance**
- Close other apps
- Restart simulator
- Reset simulator (Device → Erase All Content)

**Focus Not Working**
- Ensure views are in Button { } or have .focusable()
- Check focus system hierarchy
- Verify @FocusState is set up

### Data Persistence Issues

**Data Not Saving**
- Check `persistence.save()` is called
- Verify UserDefaults keys are correct
- Look for encoding errors

**Data Not Loading**
- Check `persistence.load()` is called in init
- Verify JSON decoding
- Check for data migration issues

---

## Git Workflow

### Branching Strategy

```
main (production-ready)
  │
  ├─ develop (integration)
  │   │
  │   ├─ feature/new-badge-system
  │   ├─ feature/icloud-sync
  │   └─ bugfix/leaderboard-crash
  │
  └─ release/1.1.0 (release preparation)
```

### Commit Messages

**Format:**
```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructure
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```
feat: Add weekly task frequency support

- Implemented WeeklyFrequency enum
- Added reset logic for weekly tasks
- Updated UI to show frequency

Closes #42
```

---

## Resources

### Apple Documentation
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [tvOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/tvos)
- [Focus System](https://developer.apple.com/documentation/swiftui/focus-management)

### Community
- [Swift Forums](https://forums.swift.org/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftui)
- [Apple Developer Forums](https://developer.apple.com/forums/)

### Tools
- [SF Symbols App](https://developer.apple.com/sf-symbols/)
- [Color Picker Tools](https://colorhunt.co/)
- [Xcode Tips](https://xcode-tips.github.io/)

---

## Code Review Checklist

**Before Submitting PR:**
- [ ] Code follows style guide
- [ ] No compiler warnings
- [ ] No force unwraps (!)
- [ ] Proper error handling
- [ ] Comments where needed
- [ ] Preview providers included
- [ ] Tested on simulator
- [ ] No print statements (use proper logging)
- [ ] No hardcoded values (use constants)
- [ ] Accessibility considered

---

## Future Development Roadmap

### Phase 1: Core Improvements
- [ ] User creation UI
- [ ] Task editing
- [ ] Category customization
- [ ] Advanced statistics

### Phase 2: Enhanced Features
- [ ] iCloud sync
- [ ] Push notifications
- [ ] Recurring task automation
- [ ] Family challenges

### Phase 3: Platform Expansion
- [ ] iOS companion app
- [ ] watchOS support
- [ ] Widget support
- [ ] SharePlay integration

---

**Happy Coding! 🚀**

*For architecture details, see ARCHITECTURE.md*
*For user documentation, see README.md and USER_GUIDE.md*
