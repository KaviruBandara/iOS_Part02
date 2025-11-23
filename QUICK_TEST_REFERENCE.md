# ⚡ Quick Test Reference

Fast reference for running tests in HouseHarmony.

---

## 🚀 Run Tests (Xcode)

| Action | Shortcut |
|--------|----------|
| **Run all tests** | `⌘ + U` |
| **Run last test** | `⌘ + Control + Option + U` |
| **Run test at cursor** | Click ◆ in gutter |
| **Test without building** | `⌘ + Control + U` |

---

## 💻 Command Line

### All Tests
```bash
xcodebuild test -project HouseHarmony.xcodeproj -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest'
```

### Unit Tests Only
```bash
xcodebuild test -project HouseHarmony.xcodeproj -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -only-testing:HouseHarmonyTests
```

### UI Tests Only
```bash
xcodebuild test -project HouseHarmony.xcodeproj -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -only-testing:HouseHarmonyUITests
```

### Specific Test Class
```bash
xcodebuild test -project HouseHarmony.xcodeproj -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -only-testing:HouseHarmonyTests/UserModelTests
```

### With Coverage
```bash
xcodebuild test -project HouseHarmony.xcodeproj -scheme HouseHarmony \
  -destination 'platform=tvOS Simulator,name=Apple TV,OS=latest' \
  -enableCodeCoverage YES -resultBundlePath TestResults.xcresult
```

---

## 📊 View Coverage

### In Xcode
1. Run tests: `⌘ + U`
2. Open Report Navigator: `⌘ + 9`
3. Select latest test run
4. Click **Coverage** tab

### Command Line
```bash
xcrun xccov view --report TestResults.xcresult
```

---

## 🧪 Available Tests

### Unit Tests (105+ tests)
- `UserModelTests` - 30+ tests
- `TaskModelTests` - 35+ tests  
- `AppStateTests` - 40+ tests

### UI Tests (55+ tests)
- `ProfileSelectionUITests` - 15+ tests
- `ChoreManagementUITests` - 20+ tests
- `LeaderboardUITests` - 20+ tests

---

## 🔧 Troubleshooting

### Tests Not Running
```bash
# Clean build
⌘ + Shift + K

# Reset simulator
xcrun simctl erase all

# Restart Xcode
```

### Simulator Issues
```bash
# Kill simulators
killall Simulator

# Erase all
xcrun simctl erase all

# List devices
xcrun simctl list devices
```

---

## 📁 Test Files Location

```
HouseHarmony/
├── HouseHarmonyTests/          # Unit tests
│   ├── UserModelTests.swift
│   ├── TaskModelTests.swift
│   ├── AppStateTests.swift
│   └── TestHelpers.swift
│
└── HouseHarmonyUITests/        # UI tests
    ├── ProfileSelectionUITests.swift
    ├── ChoreManagementUITests.swift
    ├── LeaderboardUITests.swift
    └── UITestHelpers.swift
```

---

## 📈 Coverage Stats

| Component | Coverage |
|-----------|----------|
| Models | ~95% |
| ViewModels | ~85% |
| UI Flows | ~70% |
| **Overall** | **~85%** |

---

## 📚 Documentation

- **TESTING_GUIDE.md** - Complete testing guide
- **TEST_SUMMARY.md** - Test overview
- **USER_GUIDE.md** - User + developer guide

---

## ✅ Quick Checklist

Before committing:
- [ ] Run all tests: `⌘ + U`
- [ ] Check coverage: `⌘ + 9` → Coverage
- [ ] All tests passing ✅
- [ ] Coverage > 80% ✅

---

**Everything is configured. Just press `⌘ + U` to run tests!** 🎉
