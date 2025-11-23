# 🏗️ HouseHarmony Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [MVVM Architecture](#mvvm-architecture)
3. [Data Flow](#data-flow)
4. [Layer Breakdown](#layer-breakdown)
5. [State Management](#state-management)
6. [Persistence Strategy](#persistence-strategy)
7. [Navigation Pattern](#navigation-pattern)
8. [Component Hierarchy](#component-hierarchy)

---

## Overview

HouseHarmony follows the **Model-View-ViewModel (MVVM)** architectural pattern, optimized for SwiftUI and tvOS. The architecture emphasizes:

- **Separation of Concerns**: Clear boundaries between data, logic, and presentation
- **Reactive Programming**: SwiftUI's declarative approach with Combine framework
- **Single Source of Truth**: Centralized state management
- **Reusability**: Modular, composable components
- **Testability**: Logic separated from UI for easy testing

---

## MVVM Architecture

```
┌─────────────────────────────────────────────────────┐
│                      VIEW                            │
│  (SwiftUI Views - Screens & Components)             │
│  - ProfileSelectionScreen                           │
│  - DashboardScreen                                   │
│  - ChoresScreen                                      │
│  - LeaderboardScreen                                 │
│  - ProfileStatsScreen                                │
│  - SettingsScreen                                    │
└──────────────────┬──────────────────────────────────┘
                   │
                   │ @EnvironmentObject
                   │ @Published properties
                   │ User interactions
                   ▼
┌─────────────────────────────────────────────────────┐
│                   VIEW MODEL                         │
│  (Business Logic & State)                           │
│  - AppState (ObservableObject)                      │
│    • Manages users                                   │
│    • Manages tasks                                   │
│    • Handles gamification                            │
│    • Calculates leaderboards                         │
│    • Awards badges                                   │
└──────────────────┬──────────────────────────────────┘
                   │
                   │ Read/Write
                   │ CRUD operations
                   ▼
┌─────────────────────────────────────────────────────┐
│                     MODEL                            │
│  (Data Structures)                                  │
│  - UserModel                                         │
│  - TaskModel                                         │
│  - ChoreCategory                                     │
│  - BadgeModel                                        │
│  - LeaderboardEntry                                  │
└──────────────────┬──────────────────────────────────┘
                   │
                   │ Codable
                   │ JSON Encoding/Decoding
                   ▼
┌─────────────────────────────────────────────────────┐
│                   SERVICES                           │
│  (Data Persistence)                                 │
│  - PersistenceService                               │
│    • UserDefaults storage                            │
│    • JSON serialization                              │
│    • Daily reset logic                               │
└─────────────────────────────────────────────────────┘
```

---

## Data Flow

### User Interaction Flow

```
User Action (Button Tap)
    │
    ├──→ View captures interaction
    │
    ├──→ View calls ViewModel method
    │
    ├──→ ViewModel updates Model
    │
    ├──→ ViewModel persists changes (PersistenceService)
    │
    ├──→ @Published property changes
    │
    ├──→ SwiftUI automatically re-renders View
    │
    └──→ User sees updated UI
```

### Example: Completing a Task

```
1. User taps "Complete" on TaskCard
   ↓
2. TaskCard calls: appState.completeTask(task, categoryId)
   ↓
3. AppState:
   - Finds task in choreCategories
   - Marks task as completed
   - Awards points to user
   - Increments task count
   - Updates streak
   - Checks and awards badges
   ↓
4. AppState calls: persistence.saveChoreCategories()
                    persistence.saveUsers()
   ↓
5. @Published properties trigger view updates:
   - currentUser updates → Profile header refreshes
   - choreCategories updates → Task list refreshes
   - Leaderboard recalculates automatically
   ↓
6. TaskCompletionView shows with animation
```

---

## Layer Breakdown

### 1. Models Layer (`/Models`)

**Purpose**: Define data structures

**Files**:
- `UserModel.swift`: User profile with gamification stats
- `TaskModel.swift`: Individual task with completion state
- `ChoreModel.swift`: Category containing multiple tasks
- `BadgeModel.swift`: Achievement badge definitions
- `LeaderboardEntry.swift`: Computed leaderboard ranking

**Characteristics**:
- All models are `Codable` for persistence
- Immutable data with `let` properties where possible
- Mutating methods for state changes
- Computed properties for derived values
- Sample data for testing/preview

**Example**:
```swift
struct UserModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var totalPoints: Int
    
    // Computed property
    var level: Int {
        return (totalPoints / 100) + 1
    }
    
    // Mutating method
    mutating func addPoints(_ points: Int) {
        totalPoints += points
    }
}
```

---

### 2. ViewModels Layer (`/ViewModels`)

**Purpose**: Manage state and business logic

**Files**:
- `AppState.swift`: Central application state manager

**Responsibilities**:
- Manage all app state (@Published properties)
- Handle user actions
- Coordinate between models and services
- Calculate derived data (leaderboards, stats)
- Award badges and points
- Validate business rules

**Key Methods**:
```swift
@MainActor
class AppState: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var users: [UserModel]
    @Published var choreCategories: [ChoreCategory]
    
    func selectUser(_ user: UserModel)
    func completeTask(_ task: TaskModel, in categoryId: UUID)
    func getLeaderboard() -> [LeaderboardEntry]
    func checkAndAwardBadges(for userIndex: Int)
}
```

---

### 3. Views Layer (`/Screens` + `/Components`)

**Purpose**: Display UI and handle user interactions

**Screens** (Full-page views):
- `ProfileSelectionScreen.swift`
- `DashboardScreen.swift`
- `ChoresScreen.swift`
- `TaskCompletionView.swift`
- `LeaderboardScreen.swift`
- `ProfileStatsScreen.swift`
- `SettingsScreen.swift`

**Components** (Reusable UI elements):
- `FocusableCard.swift`
- `AvatarView.swift`
- `ProgressRing.swift`
- `BadgeChip.swift`
- `ConfettiView.swift`
- `LeaderboardRow.swift`
- `TaskCard.swift`

**Characteristics**:
- Access AppState via `@EnvironmentObject`
- Declarative UI with SwiftUI
- Focus system for tvOS navigation
- Animations and transitions
- No business logic (delegate to ViewModel)

---

### 4. Services Layer (`/Services`)

**Purpose**: Handle data persistence and external operations

**Files**:
- `PersistenceService.swift`: Local storage manager

**Responsibilities**:
- Save/load data from UserDefaults
- JSON encoding/decoding
- Daily task reset logic
- Data migration (future)
- Error handling

**API**:
```swift
class PersistenceService {
    static let shared = PersistenceService()
    
    func saveUsers(_ users: [UserModel])
    func loadUsers() -> [UserModel]
    func saveChoreCategories(_ categories: [ChoreCategory])
    func loadChoreCategories() -> [ChoreCategory]
    func checkAndPerformDailyReset() -> Bool
    func resetToDefaults()
}
```

---

### 5. Utils Layer (`/Utils`)

**Purpose**: Provide helper functions and extensions

**Files**:
- `ColorExtension.swift`: Hex color support
- `AnimationHelpers.swift`: Custom animations and effects

**Utilities**:
- Color from hex string
- Focus effects modifiers
- Animation presets
- View extensions

---

## State Management

### State Hierarchy

```
App Level (Global)
│
├─ @StateObject appState: AppState
│  ├─ @Published currentUser: UserModel?
│  ├─ @Published users: [UserModel]
│  ├─ @Published choreCategories: [ChoreCategory]
│  └─ @Published showProfileSelection: Bool
│
Screen Level (Local)
│
├─ @State selectedTab: DashboardTab
├─ @State selectedCategory: ChoreCategory?
├─ @State showTaskCompletion: Bool
└─ @State completedTask: TaskModel?
```

### State Propagation

**@EnvironmentObject**: For shared state (AppState)
```swift
@EnvironmentObject var appState: AppState
```

**@Published**: For observable properties in ViewModels
```swift
@Published var users: [UserModel] = []
```

**@State**: For local view state
```swift
@State private var selectedTab: DashboardTab = .chores
```

**@Environment**: For system environment values
```swift
@Environment(\.isFocused) var isFocused
```

---

## Persistence Strategy

### Storage Mechanism: UserDefaults

**Why UserDefaults?**
- Simple for prototype/demonstration
- No complex database setup needed
- Sufficient for small-to-medium data
- Built-in to iOS/tvOS
- Automatic synchronization

### Data Structure

```json
{
  "hh_users": [
    {
      "id": "UUID-string",
      "name": "Alex",
      "avatar": "👨‍🎓",
      "colorTheme": "#FF6B6B",
      "totalPoints": 450,
      "currentStreak": 7,
      "tasksCompleted": 45,
      "badgesEarned": ["first_task", "streak_7"]
    }
  ],
  "hh_chore_categories": [
    {
      "id": "UUID-string",
      "name": "Kitchen",
      "icon": "fork.knife",
      "tasks": [...]
    }
  ]
}
```

### Persistence Flow

```
User Action → AppState updates models → PersistenceService.save()
                                             ↓
                                       JSON Encode
                                             ↓
                                      UserDefaults.set()
                                             ↓
                                    Persisted to disk
```

### Daily Reset Logic

```
App Launch → PersistenceService.checkAndPerformDailyReset()
                   ↓
           Compare last reset date with today
                   ↓
           If new day → Reset all daily frequency tasks
                   ↓
           Save updated categories
```

---

## Navigation Pattern

### Navigation Structure

```
ContentView (Root)
    │
    ├─ ProfileSelectionScreen (if no user)
    │
    └─ DashboardScreen (if user selected)
           │
           ├─ Tab 1: ChoresScreen
           │    ├─ CategoryGridView
           │    └─ TaskListView → TaskCompletionView (modal)
           │
           ├─ Tab 2: LeaderboardScreen
           │
           ├─ Tab 3: ProfileStatsScreen
           │
           └─ Tab 4: SettingsScreen
```

### Navigation Implementation

**Conditional Navigation** (ContentView):
```swift
if appState.showProfileSelection || appState.currentUser == nil {
    ProfileSelectionScreen()
} else {
    DashboardScreen()
}
```

**Tab Navigation** (DashboardScreen):
```swift
TabView(selection: $selectedTab) {
    ChoresScreen().tag(DashboardTab.chores)
    LeaderboardScreen().tag(DashboardTab.leaderboard)
    ProfileStatsScreen().tag(DashboardTab.profile)
    SettingsScreen().tag(DashboardTab.settings)
}
```

**Modal Presentation** (TaskCompletionView):
```swift
if showTaskCompletion, let task = completedTask {
    TaskCompletionView(...)
        .transition(.scale.combined(with: .opacity))
}
```

---

## Component Hierarchy

### Atomic Design Principles

```
Atoms (Basic UI elements)
├─ AvatarView
├─ BadgeChip
└─ ProgressRing

Molecules (Simple components)
├─ StatPill
├─ StatCard
└─ NavButton

Organisms (Complex components)
├─ FocusableCard
├─ TaskCard
├─ LeaderboardRow
├─ ConfettiView
├─ ProfileCard
└─ CategoryCard

Templates (Screen sections)
├─ DashboardHeader
├─ DashboardNavigationBar
├─ PodiumView
├─ StatsGrid
└─ BadgesSection

Pages (Full screens)
├─ ProfileSelectionScreen
├─ DashboardScreen
├─ ChoresScreen
├─ TaskCompletionView
├─ LeaderboardScreen
├─ ProfileStatsScreen
└─ SettingsScreen
```

### Component Composition Example

```
ChoresScreen
    ├─ CategoryGridView
    │   └─ ForEach(categories)
    │       └─ CategoryCard (Organism)
    │           ├─ Icon + Circle background (Atom)
    │           ├─ Text labels (Atom)
    │           └─ ProgressView (Molecule)
    │
    └─ TaskListView
        ├─ Header with back button
        └─ ForEach(tasks)
            └─ TaskCard (Organism)
                ├─ Task info (Molecules)
                ├─ Priority label (Molecule)
                └─ Action buttons (Atoms)
```

---

## Design Patterns Used

### 1. Singleton Pattern
**Where**: `PersistenceService.shared`
**Why**: Single point of access for data storage

### 2. Observer Pattern
**Where**: `@Published` properties in AppState
**Why**: Automatic UI updates when data changes

### 3. Factory Pattern
**Where**: Sample data generation (e.g., `UserModel.samples`)
**Why**: Easy creation of test/demo data

### 4. Dependency Injection
**Where**: `@EnvironmentObject` for AppState
**Why**: Loose coupling, easier testing

### 5. Facade Pattern
**Where**: AppState methods abstract complex logic
**Why**: Simple interface for complex operations

---

## Threading & Performance

### Main Actor
All UI updates happen on main thread:
```swift
@MainActor
class AppState: ObservableObject { ... }
```

### Lazy Loading
```swift
LazyVStack { ... }  // Only renders visible rows
LazyVGrid { ... }   // Only renders visible cells
```

### Animation Performance
- Use `.animation()` modifier sparingly
- Prefer explicit animation with `withAnimation {}`
- Hardware-accelerated animations (scale, opacity)

---

## Future Architecture Considerations

### Scalability
- **CoreData**: Replace UserDefaults for larger datasets
- **CloudKit**: Sync across devices
- **Combine**: Enhanced reactive programming

### Modularity
- **Swift Packages**: Extract components into packages
- **Feature Modules**: Separate features into modules
- **Dependency Injection**: Protocol-based dependencies

### Testing
- **Unit Tests**: Test ViewModel logic in isolation
- **UI Tests**: Test user flows with XCTest
- **Snapshot Tests**: Visual regression testing

---

## Conclusion

HouseHarmony's architecture prioritizes:
- **Simplicity**: Easy to understand and modify
- **Maintainability**: Clear separation of concerns
- **Scalability**: Ready for future enhancements
- **Performance**: Optimized for tvOS
- **User Experience**: Smooth, responsive interactions

The MVVM pattern combined with SwiftUI's reactive programming creates a robust foundation for a delightful user experience.
