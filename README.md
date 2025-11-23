# 🏠 HouseHarmony

**Multi-User Gamified Household Chore Management for tvOS**

Transform your Apple TV into a shared family dashboard that makes household chores fun, motivating, and collaborative through gamification, leaderboards, and friendly competition.

---

## 📖 Overview

HouseHarmony is a tvOS application designed to help families, roommates, and hostel groups manage household chores in a fun and engaging way. Each member creates a profile, claims tasks, earns points, unlocks badges, maintains streaks, and competes on real-time leaderboards.

The app leverages the Apple TV's position as a central living room device to create a shared experience that encourages everyone to participate in maintaining the household.

---

## ✨ Key Features

### 🎭 Multi-User Profiles
- **Unique Profiles**: Each household member has their own profile with custom avatar and color theme
- **Individual Stats**: Track personal points, tasks completed, streaks, and badges
- **Level System**: Progress through levels based on total points earned
- **Profile Customization**: Choose from emoji avatars and color themes

### 🎮 Gamification System
- **Points System**: Earn points for completing tasks (varies by task difficulty)
- **Streak Tracking**: Build daily streaks by completing tasks consistently
- **Badge Unlocking**: Unlock achievements based on milestones, streaks, and special accomplishments
- **Level Progression**: Advance through levels as you accumulate points

### 🏆 Leaderboards
- **Real-Time Rankings**: See who's leading in points and task completion
- **Podium Display**: Top 3 users showcased with special recognition
- **Multiple Periods**: View rankings for all-time, monthly, weekly, and daily
- **Personal Highlighting**: Your profile is highlighted on the leaderboard

### ✅ Task Management
- **Category Organization**: Tasks grouped by area (Kitchen, Bathroom, Living Room, etc.)
- **Task Properties**: Each task has points, priority, frequency, and description
- **Claim & Complete**: Claim tasks to show you're working on them, complete for points
- **Visual Feedback**: Celebration animations when tasks are completed

### 📊 Statistics & Analytics
- **Personal Dashboard**: View your stats, badges, and progress
- **Category Breakdown**: See which areas you've contributed to most
- **Progress Tracking**: Visual progress rings for level advancement
- **Recent Activity**: Track your most recently completed tasks

### 🎨 Beautiful UI/UX
- **tvOS Optimized**: Large, focusable cards designed for remote control navigation
- **Smooth Animations**: Spring animations, transitions, and celebration effects
- **Dark Theme**: Easy on the eyes for living room viewing
- **Pastel Colors**: Friendly, modern color palette
- **Focus Effects**: Clear visual feedback for remote control navigation

---

## 🎯 User Stories

1. **Profile Selection**: As a family member, I want to select my profile from the home screen so I can track my personal progress.

2. **View Available Tasks**: As a user, I want to see all available tasks organized by category so I can choose what to work on.

3. **Claim a Task**: As a user, I want to claim a task before starting it so others know I'm working on it.

4. **Complete a Task**: As a user, I want to complete a claimed task and see a celebration animation showing my points earned.

5. **Track My Streak**: As a user, I want to see my current streak displayed prominently so I'm motivated to maintain it.

6. **Unlock Badges**: As a user, I want to unlock achievement badges as I reach milestones to feel accomplished.

7. **Check Leaderboard**: As a competitive user, I want to see how I rank compared to other household members.

8. **View My Stats**: As a user, I want to see detailed statistics about my contributions and achievements.

9. **Switch Profiles**: As a household member, I want to easily log out and let another family member log in.

10. **See Task Progress**: As a user, I want to see what percentage of tasks in each category are completed.

11. **Level Up**: As a user, I want to see my level increase as I earn more points.

12. **Badge Collection**: As an achiever, I want to see all available badges and which ones I haven't unlocked yet.

---

## 🚀 Setup Instructions

### Requirements
- **Xcode 15.0+**
- **tvOS 17.0+**
- **Apple TV Simulator** or **Physical Apple TV device**

### Installation Steps

1. **Clone or Download the Project**
   ```bash
   cd HouseHarmony
   ```

2. **Open in Xcode**
   ```bash
   open HouseHarmony.xcodeproj
   ```

3. **Select Target**
   - In Xcode, select the tvOS simulator or a connected Apple TV device
   - Recommended: "Apple TV 4K (3rd generation)"

4. **Build and Run**
   - Press `Cmd + R` or click the Run button
   - Wait for the app to compile and launch

5. **Navigate the App**
   - Use keyboard arrows or trackpad to simulate Apple TV remote
   - Click to select focused items
   - ESC to go back (acts like remote's Back button)

---

## 🧪 Testing in Simulator

### Navigation Controls
- **Arrow Keys**: Move focus between elements
- **Enter/Space**: Select focused item
- **ESC**: Go back
- **Tab**: Alternative navigation

### Testing Flow
1. **Profile Selection**: Select one of the sample users (Alex, Sarah, Mike, or Emma)
2. **Dashboard**: Navigate through tabs (Chores, Leaderboard, Profile, Settings)
3. **Chores**: Select a category → Claim a task → Complete it
4. **Celebration**: Watch the completion animation and confetti
5. **Leaderboard**: View rankings and your position
6. **Profile**: Check your stats, badges, and level progress
7. **Settings**: Switch profiles or reset data

### Sample Data
The app comes pre-loaded with:
- **4 Sample Users** with varying stats and achievements
- **6 Task Categories** (Kitchen, Bathroom, Living Room, Bedroom, Laundry, Outdoor)
- **30+ Tasks** across all categories
- **18 Unlockable Badges** for various achievements

---

## 🏗️ Architecture

### MVVM Pattern

```
HouseHarmony/
├── Models/              # Data models (User, Task, Badge, etc.)
├── ViewModels/          # Business logic and state management
├── Views/               # Reusable view components
├── Screens/             # Full-screen views
├── Components/          # UI components (cards, badges, etc.)
├── Services/            # Persistence and data services
├── Utils/               # Helper functions and extensions
└── Assets.xcassets/     # Images and color assets
```

### Data Flow

```
┌─────────────┐
│ ContentView │ ← Main container
└──────┬──────┘
       │
       ├─→ ProfileSelectionScreen (if no user selected)
       │
       └─→ DashboardScreen (if user selected)
           │
           ├─→ ChoresScreen
           │   ├─→ CategoryGridView
           │   ├─→ TaskListView
           │   └─→ TaskCompletionView
           │
           ├─→ LeaderboardScreen
           │   └─→ PodiumView
           │
           ├─→ ProfileStatsScreen
           │   ├─→ StatsGrid
           │   └─→ BadgesSection
           │
           └─→ SettingsScreen
```

### State Management

**AppState** (ObservableObject)
- Central state manager for the entire app
- Manages users, tasks, categories, and current user
- Handles data persistence
- Calculates leaderboards and stats
- Awards badges and points

**PersistenceService**
- Singleton service for local data storage
- Uses UserDefaults with JSON encoding
- Handles daily task resets
- Manages data import/export

---

## 📁 File Structure

### Models
- **UserModel.swift**: User profile with stats and gamification data
- **TaskModel.swift**: Individual task with completion tracking
- **ChoreModel.swift**: Category grouping for tasks
- **BadgeModel.swift**: Achievement badge definitions
- **LeaderboardEntry.swift**: Leaderboard ranking data

### ViewModels
- **AppState.swift**: Main application state and logic

### Services
- **PersistenceService.swift**: Local data storage and retrieval

### Components
- **FocusableCard.swift**: Reusable focusable card container
- **AvatarView.swift**: User avatar display
- **ProgressRing.swift**: Circular progress indicator
- **BadgeChip.swift**: Badge display component
- **ConfettiView.swift**: Celebration confetti animation
- **LeaderboardRow.swift**: Leaderboard entry row
- **TaskCard.swift**: Task display card

### Screens
- **ProfileSelectionScreen.swift**: User profile selection
- **DashboardScreen.swift**: Main dashboard with navigation
- **ChoresScreen.swift**: Category and task views
- **TaskCompletionView.swift**: Completion celebration
- **LeaderboardScreen.swift**: Rankings and podium
- **ProfileStatsScreen.swift**: User statistics and badges
- **SettingsScreen.swift**: App settings and options

### Utils
- **ColorExtension.swift**: Hex color support
- **AnimationHelpers.swift**: Custom animations and effects

---

## 🎨 Design Philosophy

### Color Palette
- **Background**: Dark navy (#1A1A2E) for reduced eye strain
- **Cards**: Lighter navy (#16213E) for content containers
- **Accents**: User-specific colors from pastel palette
- **System**: Yellow (points), Orange (streaks), Green (completion)

### Typography
- **Large Sizes**: Optimized for TV viewing distance (10-foot UI)
- **Heavy Weights**: Bold fonts for primary information
- **Clear Hierarchy**: Title → Subtitle → Body progression

### Interaction Design
- **Focus-Driven**: All interactions designed around tvOS focus system
- **Scale Effects**: Focused items scale up 5-8%
- **Border Highlights**: White borders indicate focus
- **Shadow Glow**: Soft shadows enhance focus feedback
- **Smooth Animations**: Spring animations for natural feel

---

## 🔮 Future Improvements

### Short-Term
- [ ] Add user creation flow with avatar/color picker
- [ ] Implement period filtering for leaderboard (daily, weekly, monthly)
- [ ] Add task editing and creation
- [ ] Weekly/monthly task frequency support
- [ ] Push notifications for task reminders
- [ ] Family challenges and shared goals

### Medium-Term
- [ ] iCloud sync across devices
- [ ] iOS companion app for task management on the go
- [ ] Customizable badge system
- [ ] Task templates and categories
- [ ] Reward redemption system
- [ ] Profile avatars with photos
- [ ] Dark/Light theme toggle

### Long-Term
- [ ] AI-powered task suggestions
- [ ] Integration with smart home devices
- [ ] Family calendar integration
- [ ] Shopping list integration
- [ ] Chore scheduling and reminders
- [ ] Multi-household support
- [ ] Social features (compare with friends' families)

---

## 🛠️ Technical Details

### Persistence
- **Storage**: UserDefaults with JSON encoding/decoding
- **Auto-Save**: Changes persisted immediately
- **Daily Reset**: Automatic daily task reset at midnight
- **Data Recovery**: Sample data loaded if storage is empty

### Gamification Logic

**Points System**
- Low priority tasks: 5 points
- Medium priority tasks: 10 points
- High priority tasks: 20 points
- Custom points per task

**Level Calculation**
- Level = (Total Points / 100) + 1
- Each level requires 100 points

**Badge Unlocking**
- Milestone badges: Based on total tasks completed
- Streak badges: Based on consecutive days
- Points badges: Based on total points
- Category badges: Based on category-specific tasks
- Special badges: Time-based and special achievements

**Streak System**
- Increments when task completed same day
- Resets if no task completed for a day
- Tracks both current and longest streak

---

## 🧑‍💻 Development

### Code Style
- **SwiftUI**: Pure SwiftUI, no UIKit
- **MVVM**: Clean separation of concerns
- **Naming**: Clear, descriptive names
- **Comments**: Comprehensive documentation
- **Organization**: Logical file structure

### Best Practices
- Use `@Published` for observable properties
- Leverage `@EnvironmentObject` for shared state
- Focus system for all interactive elements
- Accessibility-first design
- Performance-optimized animations

---

## 📄 License

This project is created for educational purposes.

---

## 🤝 Contributing

This is a prototype/demonstration project. Feel free to:
- Fork and modify for your own use
- Submit issues for bugs
- Suggest features and improvements
- Share your customizations

---

## 📞 Support

For questions or issues:
- Check the code comments for inline documentation
- Review the architecture diagram above
- Test with sample data first
- Ensure tvOS 17.0+ compatibility

---

## 🎉 Acknowledgments

Built with:
- **SwiftUI**: Apple's declarative UI framework
- **tvOS**: Apple's TV platform
- **Xcode**: Apple's development environment

Designed for:
- **Families** looking to gamify household chores
- **Roommates** wanting fair task distribution
- **Hostel groups** managing shared spaces
- **Anyone** who wants to make chores more fun!

---

**Made with ❤️ for HouseHarmony**

*Turning chores into achievements, one task at a time.*
