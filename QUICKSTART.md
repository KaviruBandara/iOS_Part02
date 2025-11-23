# ⚡ HouseHarmony Quick Start Guide

**Get Running in 5 Minutes**

---

## 🎯 Immediate Steps

### 1. Open in Xcode (30 seconds)

```bash
cd /Users/imstudent/Documents/KaviruAssignment2Part2/HouseHarmony
open HouseHarmony.xcodeproj
```

### 2. Select Target (10 seconds)

- **Top Bar**: Click device selector
- **Choose**: Apple TV (or any Apple TV simulator)

### 3. Build & Run (2 minutes)

- Press **Cmd + R**
- Wait for build to complete
- App launches automatically

---

## 🎮 First Experience (2 minutes)

### Step-by-Step Test Flow

**1. Profile Selection**
```
→ Use arrow keys to navigate
→ Focus on "Sarah" profile
→ Press Enter to select
```

**2. Dashboard View**
```
→ See your stats in header
→ Bottom nav shows 4 tabs
→ Currently on "Chores" tab
```

**3. Select Category**
```
→ Navigate to "Kitchen" card
→ Press Enter to select
```

**4. Claim a Task**
```
→ Find "Wash dishes" task
→ Navigate to "Claim Task" button
→ Press Enter
→ Status changes to "Claimed"
```

**5. Complete Task**
```
→ Navigate to "Complete" button
→ Press Enter
→ 🎉 CELEBRATION APPEARS!
→ Confetti animation plays
→ Points displayed (+15)
→ Press Enter on "Continue"
```

**6. Check Results**
```
→ Press ESC to go back
→ Navigate to "Leaderboard" tab
→ See Sarah's position updated
→ Navigate to "Profile" tab
→ See updated stats and badges
```

---

## 🕹️ Controls Reference

### Keyboard (Simulator)
| Key | Action |
|-----|--------|
| ↑↓←→ | Move focus |
| Enter | Select |
| Space | Alternative select |
| ESC | Back |

### Apple TV Remote
| Control | Action |
|---------|--------|
| Swipe | Move focus |
| Click | Select |
| Menu | Back |

---

## 📊 Sample Users

Select any of these pre-loaded profiles:

| User | Avatar | Points | What to Try |
|------|--------|--------|-------------|
| **Emma** 👧 | 890 pts | Check highest scorer |
| **Sarah** 👩‍💼 | 680 pts | Best for testing |
| **Alex** 👨‍🎓 | 450 pts | Mid-range stats |
| **Mike** 👨‍🍳 | 320 pts | Lowest scorer |

---

## 🎯 Quick Tests

### Test 1: Task Completion (1 min)
```
Profile → Chores → Kitchen → Claim → Complete → Celebration
```

### Test 2: Leaderboard (30 sec)
```
Leaderboard Tab → See rankings → Find your user
```

### Test 3: Profile Stats (30 sec)
```
Profile Tab → View stats → Scroll badges
```

### Test 4: Switch Users (30 sec)
```
Settings Tab → Switch Profile → Select new user
```

---

## ✅ What You Should See

### ✓ Profile Selection Screen
- 4 user cards with avatars
- Color-coded themes
- Stats displayed (points, streak, level)
- Focus effects when navigating

### ✓ Dashboard
- App logo and user info in header
- 4 navigation tabs at bottom
- Smooth tab switching

### ✓ Chores Screen
- 6 category cards in grid
- Icons and progress bars
- Category selection navigation

### ✓ Task List
- Task cards with details
- Points badges
- Claim/Complete buttons
- Priority indicators

### ✓ Completion Animation
- Confetti particles falling
- Checkmark icon
- Points earned display
- Success message

### ✓ Leaderboard
- Top 3 podium display
- Full rankings list
- Medal emojis (🥇🥈🥉)
- Your entry highlighted

### ✓ Profile Stats
- Large avatar
- Stats grid (6 cards)
- Progress ring for level
- Badge collection

---

## 🐛 Troubleshooting

### Build Failed?
```bash
# Clean build folder
Cmd + Shift + K
# Rebuild
Cmd + B
```

### Simulator Not Showing?
```
Xcode → Window → Devices and Simulators
→ Add Apple TV Simulator
```

### App Crashes on Launch?
```
Check console (Cmd + Shift + Y) for errors
Most common: Missing @EnvironmentObject
```

### Focus Not Working?
```
Ensure you're using arrow keys, not mouse
Simulator must be active window
```

---

## 📱 File Locations

**Quick Navigation:**

```
Models:           HouseHarmony/Models/
Screens:          HouseHarmony/Screens/
Components:       HouseHarmony/Components/
ViewModels:       HouseHarmony/ViewModels/
Services:         HouseHarmony/Services/

Main Files:
- HouseHarmonyApp.swift (Entry point)
- ContentView.swift (Root view)
- AppState.swift (State management)
```

---

## 🎨 Customization Quick Tips

### Change Sample User Data
**File**: `Models/UserModel.swift`
```swift
// Line ~80: Edit UserModel.samples array
```

### Change Colors
**File**: `Utils/ColorExtension.swift`
```swift
// Line ~40: Edit theme color constants
```

### Add New Task
**File**: `Models/ChoreModel.swift`
```swift
// In ChoreCategory.samples, add TaskModel to tasks array
```

### Modify Point Values
**File**: `Models/TaskModel.swift`
```swift
// Line ~20: Edit TaskPriority.points computed property
```

---

## 📚 Full Documentation

For detailed information:

| Topic | File |
|-------|------|
| **Overview & Setup** | README.md |
| **Architecture** | ARCHITECTURE.md |
| **User Guide** | USER_GUIDE.md |
| **Development** | DEVELOPMENT.md |
| **Summary** | PROJECT_SUMMARY.md |

---

## ✨ Key Features to Demo

1. **Multi-User**: Switch between 4 profiles
2. **Gamification**: Earn points, streaks, badges
3. **Animations**: Smooth focus effects and celebrations
4. **Leaderboard**: Real-time rankings
5. **Categories**: 6 task categories
6. **Persistence**: Data saves automatically

---

## 🚀 Success Criteria

You'll know it's working when:

- ✅ Profile selection shows 4 users
- ✅ Dashboard displays user stats
- ✅ Categories show with icons
- ✅ Tasks can be claimed and completed
- ✅ Celebration animation appears
- ✅ Leaderboard updates
- ✅ Profile stats increase
- ✅ Badges unlock
- ✅ Data persists after restart

---

## 💡 Pro Tips

1. **Use Emma's profile** for highest stats demo
2. **Complete "Wash dishes"** for quick 15 points
3. **Check leaderboard** after each task
4. **Switch profiles** to see different perspectives
5. **Reset data** in Settings to start fresh

---

## ⏱️ Time Estimates

| Task | Duration |
|------|----------|
| Open & Build | 2 minutes |
| Test Task Flow | 1 minute |
| Explore All Screens | 3 minutes |
| **Total** | **~6 minutes** |

---

## 🎉 You're Ready!

Press **Cmd + R** and start exploring HouseHarmony!

---

*For any issues, check the full README.md or DEVELOPMENT.md*
