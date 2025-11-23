# 📺 tvOS Navigation Guide for HouseHarmony

**Complete guide for navigating the app in tvOS Simulator**

---

## ✅ Fixed for tvOS Simulator

All interactive elements have been updated to work properly with tvOS focus system and remote control navigation.

### What Was Fixed

1. **ProfileSelectionScreen** - Profile cards now properly respond to selection
2. **ChoresScreen** - Category cards now properly respond to selection
3. All buttons now use proper action closures instead of tap gestures

---

## 🎮 How to Navigate in tvOS Simulator

### Keyboard Controls (Recommended)

| Key | Action | Usage |
|-----|--------|-------|
| **↑ ↓ ← →** | Move focus | Navigate between cards, buttons, tabs |
| **Enter** | Select | Click the focused item |
| **Space** | Select (alt) | Alternative to Enter |
| **ESC** | Go back | Return to previous screen |

### On-Screen Remote (Optional)

1. Go to `Window > Show Apple TV Remote`
2. **Swipe** on trackpad area to move focus
3. **Click** center to select
4. **Menu button** to go back

---

## 📱 Complete Navigation Flow

### 1. Profile Selection Screen

**What you see:**
- 4 user profile cards (Alex, Sarah, Mike, Emma)
- "Add User" card with dashed border

**How to navigate:**
1. Use **arrow keys** to move between profile cards
2. Focused card will have:
   - White border (5px)
   - Slightly larger size (1.08x scale)
   - White glow shadow
3. Press **Enter** on a profile to select it
4. App navigates to Dashboard

**Test it:**
```
Arrow keys → Focus on "Sarah" → Enter → Dashboard appears
```

---

### 2. Dashboard Screen

**What you see:**
- Header with app logo and user info
- Main content area (shows current tab)
- Bottom navigation bar with 4 tabs

**Bottom Navigation Tabs:**
- 🏠 **Chores** (default)
- 🏆 **Leaderboard**
- 👤 **Profile**
- ⚙️ **Settings**

**How to navigate:**
1. Use **arrow keys** to move between tabs
2. Focused tab will have:
   - White border
   - Larger size (1.1x scale)
3. Press **Enter** to switch tabs
4. Content area updates automatically

**Test it:**
```
Arrow down → Focus navigation bar
Arrow right → Focus "Leaderboard" tab → Enter
Content switches to leaderboard
```

---

### 3. Chores Tab

#### Category Selection

**What you see:**
- Grid of 6 category cards:
  - 🍴 Kitchen
  - 🚿 Bathroom
  - 🛋️ Living Room
  - 🛏️ Bedroom
  - 🧺 Laundry
  - 🌿 Outdoor

**How to navigate:**
1. Use **arrow keys** to move between categories
2. Focused category will have:
   - White border
   - Larger size (1.08x scale)
   - White glow
3. Press **Enter** to open category
4. Task list appears

**Test it:**
```
Arrow keys → Focus "Kitchen" → Enter → Task list appears
```

#### Task List

**What you see:**
- Back button (top left)
- Category header with icon and name
- List of tasks with:
  - Title and description
  - Points badge (⭐)
  - Priority indicator
  - Status (Available/Claimed/Completed)
  - Action buttons

**How to navigate:**
1. Use **arrow keys** to move between tasks and buttons
2. For available tasks:
   - Focus "Claim Task" button → **Enter** to claim
3. For claimed tasks:
   - Focus "Complete" button → **Enter** to complete
4. Celebration screen appears
5. Press **ESC** or use back button to return

**Test it:**
```
Focus "Wash dishes" task
Arrow down → Focus "Claim Task" → Enter (task claimed)
Arrow down → Focus "Complete" → Enter (celebration!)
```

---

### 4. Task Completion Celebration

**What you see:**
- Dark overlay
- Confetti animation
- Large checkmark icon
- "Task Completed!" message
- Points earned (+15, +20, etc.)
- "Continue" button

**How to navigate:**
1. Button is auto-focused
2. Press **Enter** to dismiss
3. Returns to task list

**Test it:**
```
Wait for animation → Enter → Back to tasks
```

---

### 5. Leaderboard Tab

**What you see:**
- Top 3 podium display:
  - 🥇 1st place (tallest)
  - 🥈 2nd place (medium)
  - 🥉 3rd place (shortest)
- Full rankings list below
- Your entry is highlighted

**How to navigate:**
1. Use **arrow keys** to scroll through rankings
2. Items are focusable for visual feedback
3. No actions needed (display only)

**Test it:**
```
Arrow keys → Scroll through leaderboard
Find your highlighted entry
```

---

### 6. Profile Tab

**What you see:**
- Large avatar and name
- Stats pills (Level, Points, Streak)
- 6 stat cards in grid
- Level progress ring
- Badge collection (unlocked and locked)

**How to navigate:**
1. Use **arrow keys** to move between stat cards
2. Scroll down to see badges
3. Unlocked badges are colorful
4. Locked badges are grayed out with lock icon

**Test it:**
```
Arrow keys → Navigate stat cards
Scroll down → View badges
```

---

### 7. Settings Tab

**What you see:**
- Account section:
  - Switch Profile button
- Data section:
  - Reset Daily Tasks
  - Reset All Data
- About section (info only)

**How to navigate:**
1. Use **arrow keys** to move between options
2. Focused option has colored background
3. Press **Enter** to activate

**Actions:**
- **Switch Profile**: Returns to profile selection
- **Reset Daily Tasks**: Clears daily task completions
- **Reset All Data**: Shows confirmation alert

**Test it:**
```
Arrow keys → Focus "Switch Profile" → Enter
Returns to profile selection screen
```

---

## 🎯 Complete Test Flow

### Full App Walkthrough (5 minutes)

```
1. Launch app
   ↓
2. Profile Selection
   - Arrow keys → "Sarah"
   - Enter → Dashboard
   ↓
3. Chores Tab (default)
   - Arrow keys → "Kitchen" category
   - Enter → Task list
   ↓
4. Claim Task
   - Arrow keys → "Wash dishes"
   - Arrow down → "Claim Task"
   - Enter → Task claimed
   ↓
5. Complete Task
   - Arrow down → "Complete"
   - Enter → Celebration! 🎉
   - Enter → Dismiss
   ↓
6. Check Leaderboard
   - ESC → Back to categories
   - Arrow down → Navigation bar
   - Arrow right → "Leaderboard"
   - Enter → View rankings
   ↓
7. Check Profile
   - Arrow right → "Profile"
   - Enter → View stats
   - Scroll → See badges
   ↓
8. Switch User
   - Arrow right → "Settings"
   - Enter → Settings screen
   - Arrow down → "Switch Profile"
   - Enter → Back to profile selection
```

---

## 🐛 Troubleshooting

### Focus Not Moving

**Problem**: Arrow keys don't move focus
**Solution**: 
- Click on simulator window to make it active
- Make sure you're not in a text field
- Try pressing Tab to reset focus

### Can't Select Items

**Problem**: Enter key doesn't work
**Solution**:
- Make sure item is focused (white border visible)
- Try Space key as alternative
- Check if button is disabled (grayed out)

### Simulator Not Responding

**Problem**: Simulator frozen or laggy
**Solution**:
- Restart simulator: Device → Restart
- Clean build: Cmd + Shift + K
- Rebuild: Cmd + B
- Run again: Cmd + R

### Wrong Screen Showing

**Problem**: App shows wrong screen after navigation
**Solution**:
- Press ESC to go back
- Use Settings → Switch Profile to reset
- Restart app

---

## 💡 Pro Tips

### For Smooth Demo

1. **Start with Sarah** - She has good stats for demo
2. **Use Kitchen category** - Most familiar tasks
3. **Complete "Wash dishes"** - Quick 15 points
4. **Show celebration** - Impressive animation
5. **Check leaderboard** - Show rankings update
6. **View profile** - Show stats increase

### For Testing All Features

1. **Complete multiple tasks** - Test different categories
2. **Build a streak** - Complete tasks daily
3. **Unlock badges** - Reach milestones
4. **Compare users** - Switch profiles
5. **Reset data** - Start fresh for new demo

### Keyboard Shortcuts

- **Cmd + R**: Run app
- **Cmd + .**: Stop app
- **Cmd + Shift + K**: Clean build
- **ESC**: Go back in app

---

## 📊 What's Focusable

### Interactive Elements (Can Select)

✅ Profile cards
✅ Category cards  
✅ Task cards
✅ Claim/Complete buttons
✅ Navigation tabs
✅ Settings buttons
✅ Continue button (celebration)
✅ Back button

### Display Elements (Visual Focus Only)

👁️ Stat cards (profile screen)
👁️ Leaderboard rows
👁️ Podium cards
👁️ Badge chips
👁️ Progress rings

---

## 🎨 Focus Visual Indicators

When an item is focused, you'll see:

1. **White border** (4-5px thick)
2. **Scale effect** (1.05-1.1x larger)
3. **White glow shadow** (soft outer glow)
4. **Smooth animation** (spring physics)

These indicators make it easy to see what's selected!

---

## ✨ Success Criteria

You'll know navigation is working when:

- ✅ Focus moves smoothly with arrow keys
- ✅ White borders appear on focused items
- ✅ Items scale up when focused
- ✅ Enter key selects focused items
- ✅ Screens transition smoothly
- ✅ Back navigation works (ESC)
- ✅ Tabs switch properly
- ✅ Tasks can be claimed and completed
- ✅ Celebration appears after completion
- ✅ Profile switching works

---

## 🚀 Ready to Demo!

Your app is now fully navigable in the tvOS simulator. All interactive elements respond properly to remote control input.

**Quick Start:**
1. Run app (Cmd + R)
2. Select profile (Arrow + Enter)
3. Navigate with arrows
4. Select with Enter
5. Go back with ESC

**Enjoy demonstrating HouseHarmony! 🏠✨**

---

*Last Updated: November 23, 2024*
*All navigation fixes applied and tested*
