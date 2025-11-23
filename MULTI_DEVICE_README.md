# HouseHarmony Multi-Device Architecture

## 🏠 Overview

HouseHarmony is a **multi-user, multi-device gamified household chore management system** for tvOS. The Apple TV acts as the central **HOST**, while external devices (iPhones/iPads) connect as **CLIENTS** to interact with shared household data in real-time.

## 🎯 Core Concept

### Host-Client Architecture

```
┌─────────────────────────────────────────┐
│         Apple TV (HOST)                 │
│  - Central household dashboard          │
│  - Session manager                      │
│  - Data persistence                     │
│  - Admin controls                       │
│  - Real-time event display              │
└──────────────┬──────────────────────────┘
               │
               │  Simulated Network Layer
               │
      ┌────────┴────────┬────────┬────────┐
      │                 │        │        │
  ┌───▼───┐      ┌─────▼──┐  ┌──▼───┐  ┌─▼────┐
  │iPhone │      │ iPad   │  │iPhone│  │iPhone│
  │(Emma) │      │ (Mike) │  │(Sarah│  │(Alex)│
  └───────┘      └────────┘  └──────┘  └──────┘
   CLIENT         CLIENT      CLIENT    CLIENT
```

### Multi-User Session Flow

1. **TV starts hosting** → Generates 4-digit pairing code
2. **External devices connect** → Enter pairing code
3. **Admin approves devices** → Assigns to user profiles
4. **Clients perform actions** → TV updates in real-time
5. **All users see changes** → Leaderboard, points, tasks

---

## 📱 Multi-Device Features

### Session Management

#### Start Hosting
- Navigate to: **Settings → House Session Manager**
- Tap **"Start Hosting Session"**
- System generates unique 4-digit pairing code
- Session begins broadcasting (simulated)

#### Pairing Code Display
- Shows 4-digit code in large, readable format
- Instructions for connecting devices
- Code remains valid while hosting

#### Connected Devices
- Real-time list of all devices
- Status indicators: Connected, Pending, Disconnected, Blocked
- Device details: Name, type (iPhone/iPad), connection time

### Device Management

#### Approve/Reject Devices
- New devices appear as "Pending"
- Admin can:
  - ✅ **Approve** → Device connects
  - ❌ **Reject** → Device removed
  - 🚫 **Block** → Device permanently banned

#### Assign Device to User
- Connect device to specific user profile
- All actions from that device are attributed to the user
- Updates user's points, streaks, badges

#### Simulate Device Actions
- **Client Action Simulator** screen
- Simulates actions from connected devices:
  - 🖐️ Claim Task
  - ✅ Complete Task  
  - ➕ Create Task
  - ➡️ Assign Task to User

### Real-Time Activity Feed

#### Live Event Stream
- Shows recent actions from all devices
- Displays:
  - Action type (claimed, completed, created, assigned)
  - User name
  - Device name
  - Timestamp
  - Task details
- Color-coded by action type
- Auto-scrolls to latest events

---

## 🗂️ Data Models

### DeviceModel
```swift
struct DeviceModel {
    let id: UUID
    var name: String                    // "Emma's iPhone"
    var deviceType: String             // "iPhone", "iPad"
    var isApproved: Bool               // Admin approval
    var isBlocked: Bool                // Blocked status
    var assignedUserId: UUID?          // Linked user
    var status: DeviceStatus           // Connection state
    var connectionTime: Date?          // When connected
    var lastActivity: Date?            // Last action timestamp
    var pairingCode: String?           // Code used to connect
}
```

### DeviceStatus
```swift
enum DeviceStatus {
    case connected      // Actively connected
    case disconnected   // Not connected
    case pending        // Waiting for approval
    case blocked        // Admin blocked
}
```

### DeviceAction
```swift
struct DeviceAction {
    let id: UUID
    let deviceId: UUID
    let deviceName: String
    let userId: UUID?
    let userName: String?
    let actionType: DeviceActionType
    let timestamp: Date
    var details: String
}
```

### DeviceActionType
```swift
enum DeviceActionType {
    case claimedTask      // User claimed a task
    case completedTask    // User completed a task
    case createdTask      // User created new task
    case assignedTask     // User assigned task to someone
    case connected        // Device connected
    case disconnected     // Device disconnected
}
```

### HouseSession
```swift
struct HouseSession {
    var householdId: String              // "BandaraHome"
    var householdName: String            // "Bandara Family"
    var isHosting: Bool                  // Currently hosting?
    var pairingCode: String              // 4-digit code
    var startTime: Date?                 // When hosting started
    var connectedDevices: [DeviceModel]  // All devices
    var recentActions: [DeviceAction]    // Activity feed
}
```

---

## 🏗️ Architecture

### MVVM Structure

```
Models/
├── DeviceModel.swift           ✅ NEW
├── UserModel.swift             
├── ChoreCategory.swift         
├── TaskModel.swift             
└── BadgeModel.swift            

ViewModels/
├── HouseSessionViewModel.swift ✅ NEW
├── AppState.swift              
└── ...

Screens/
├── HouseSessionHostScreen.swift        ✅ NEW
├── ConnectedDevicesScreen.swift        ✅ NEW
├── PairingCodeScreen.swift             ✅ NEW
├── ClientActionSimulatorScreen.swift   ✅ NEW
├── DashboardScreen.swift               
├── ProfileSelectionScreen.swift        
└── ...

Services/
└── PersistenceService.swift    (Updated)
```

### HouseSessionViewModel

Manages all multi-device functionality:

```swift
class HouseSessionViewModel: ObservableObject {
    @Published var session: HouseSession
    
    // Session Control
    func startHosting()
    func stopHosting()
    func regeneratePairingCode()
    
    // Device Management
    func simulateNewDevice()
    func approveDevice(_ device: DeviceModel)
    func rejectDevice(_ device: DeviceModel)
    func blockDevice(_ device: DeviceModel)
    func disconnectDevice(_ device: DeviceModel)
    func assignDeviceToUser(_ device: DeviceModel, userId: UUID)
    
    // Simulated Actions
    func simulateClaimTask(device: DeviceModel, task: TaskModel, userName: String)
    func simulateCompleteTask(device: DeviceModel, task: TaskModel, userName: String)
    func simulateCreateTask(device: DeviceModel, taskName: String, userName: String)
    func simulateAssignTask(device: DeviceModel, taskName: String, toUser: String, userName: String)
}
```

---

## 🎮 User Experience

### Multi-User Scenarios

#### Scenario 1: Mom Starts Session
1. Mom (Admin) opens Settings → House Session Manager
2. Taps "Start Hosting Session"
3. TV displays pairing code: **1234**
4. Family members see code on TV

#### Scenario 2: Emma Connects
1. Emma opens HouseHarmony app on iPhone
2. Taps "Connect to TV"
3. Enters code: **1234**
4. TV shows: "Emma's iPhone is requesting to connect"
5. Mom approves → Emma's device connected
6. Mom assigns device to Emma's profile

#### Scenario 3: Emma Claims Task
1. Emma sees "Clean Kitchen" on her iPhone
2. Taps "Claim Task"
3. **INSTANTLY** → TV updates:
   - Task marked as "Claimed by Emma"
   - Activity feed shows: "Emma claimed Clean Kitchen"
   - Emma's avatar appears on task card

#### Scenario 4: Mike Completes Task
1. Mike finishes "Vacuum Living Room" on his iPad
2. Taps "Complete"
3. **INSTANTLY** → TV updates:
   - Confetti animation 🎉
   - Mike earns +50 points
   - Leaderboard refreshes
   - Activity feed shows: "Mike completed Vacuum Living Room (+50 pts)"
   - Mike's streak increases

---

## 🧪 Testing the Simulation

### How to Test Multi-Device Features

1. **Start Hosting**
   - Settings → House Session Manager
   - Start Hosting Session
   - Note the pairing code

2. **Add Simulated Devices**
   - Connected Devices → "Simulate New Device Connecting"
   - Approve the pending device
   - Assign to a user profile

3. **Simulate Actions**
   - Client Action Simulator
   - Select a connected device
   - Tap action buttons:
     - Claim Random Task
     - Complete Random Task
     - Create Task
     - Assign Task to User

4. **Watch Real-Time Updates**
   - Return to Dashboard
   - See updated points, tasks, leaderboard
   - Check activity feed for events

---

## 🎨 UI Theme Consistency

All new multi-device screens follow the exact same design language:

### Visual Elements
- **Ocean gradient background** (`LinearGradient.oceanGradient`)
- **Glassmorphism cards** with blur effect
- **Color-coded actions**: Green (approve), Red (reject), Purple (admin), Cyan (info)
- **Smooth animations**: Spring animations (0.3s response, 0.7 damping)
- **Focus effects**: 1.05 scale, colored glow, 3px border
- **Typography**: System font, bold weights, white text

### Interactive Elements
- **Buttons**: Scale on focus, colored gradient backgrounds
- **Cards**: Hover effects, dynamic opacity changes
- **Icons**: SF Symbols, color-coded by function
- **Status badges**: Capsule shape, semi-transparent fills

---

## 🔧 Technical Implementation

### Simulated Networking

Since this is a prototype, networking is **simulated**:

- No real WebSocket/HTTP connections
- All actions use local state management
- Events stored in memory (UserDefaults for persistence)
- Device actions trigger ViewModel methods
- UI updates via Combine (@Published properties)

### Data Flow

```
Client Simulator Button
       ↓
HouseSessionViewModel.simulateAction()
       ↓
Update session.recentActions
       ↓
Trigger AppState update (e.g., completeTask)
       ↓
SwiftUI View Re-renders
       ↓
TV Dashboard Updates
```

### Persistence

- `HouseSession` saved to UserDefaults
- Device list persists between app launches
- Activity feed kept (last 50 actions)
- Session state restored on app restart

---

## 📊 Admin Features

### Admin-Only Capabilities

Admins (users with `isAdmin: true`) can:

1. **Session Management**
   - Start/stop hosting
   - Regenerate pairing codes

2. **Device Permissions**
   - Approve/reject/block devices
   - Assign devices to users
   - View device details

3. **Task Management** (existing)
   - Create/edit/delete categories
   - Create/edit/delete task templates
   - Assign tasks to users
   - Set custom points

4. **Data Control**
   - Reset daily tasks
   - Clear all data
   - View full activity history

---

## 🚀 Future Enhancements

### Potential Real Implementation

To make this a real multi-device app:

1. **Networking Layer**
   - WebSocket server on TV
   - iOS client apps
   - Real-time bidirectional communication

2. **Security**
   - Encrypted connections
   - User authentication
   - Device authorization tokens

3. **Cloud Sync**
   - iCloud integration
   - Multi-household support
   - Data backup

4. **Enhanced Features**
   - Push notifications
   - Voice commands (Siri)
   - Calendar integration
   - Photo attachments for tasks

---

## 📝 User Stories

### Story 1: Family Game Night Setup
**As a parent**, I want to set up HouseHarmony on the TV so the whole family can participate together.

**Steps:**
1. Open app on Apple TV
2. Navigate to Settings → House Session Manager
3. Start Hosting Session
4. Display pairing code on TV
5. Each family member connects their device
6. Approve all devices
7. Assign devices to profiles
8. Ready to use!

### Story 2: Real-Time Task Completion
**As a user on my iPhone**, I want to complete a task and see the TV update immediately.

**Steps:**
1. Open HouseHarmony app on iPhone
2. Browse available tasks
3. Claim "Wash Dishes"
4. Complete the task
5. Tap "Complete"
6. **TV shows**: Confetti animation, points added, leaderboard updated
7. **iPhone shows**: Confirmation, badge earned

### Story 3: Admin Approves New Device
**As an admin**, I want to control which devices can connect to our household.

**Steps:**
1. New device requests connection
2. TV shows notification: "Alex's iPhone is requesting to connect"
3. Navigate to Connected Devices
4. Review device details
5. Tap "Approve"
6. Assign to Alex's profile
7. Device now connected and active

### Story 4: Multi-User Collaboration
**As a family**, we want to see everyone's contributions in real-time.

**Scenario:**
- Emma claims "Clean Kitchen" from her iPhone → TV updates
- Mike completes "Take Out Trash" from his iPad → TV shows confetti
- Sarah creates new task "Water Plants" from her iPhone → TV adds to list
- Alex assigns "Vacuum Room" to Emma from his iPhone → Emma sees notification
- **Everyone** sees the activity feed update in real-time on TV

---

## 🎯 Key Differentiators

What makes HouseHarmony's multi-device approach unique:

1. **TV as Central Hub**
   - Visual focal point for the family
   - Encourages group participation
   - Gamification visible to all

2. **Real-Time Collaboration**
   - Multiple users, multiple devices, same session
   - Instant feedback and updates
   - Competitive and cooperative elements

3. **Admin Controls**
   - Parent oversight
   - Device management
   - Customizable rules

4. **Simulated Yet Functional**
   - Demonstrates full concept
   - No backend required for prototype
   - Easy to test and demo

---

## 📦 Setup & Installation

### Requirements
- Xcode 15.0+
- tvOS 17.0+
- Swift 5.9+

### Running the App

1. Open `HouseHarmony.xcodeproj`
2. Select Apple TV simulator
3. Build and run
4. Navigate to Settings → House Session Manager
5. Start Hosting
6. Use Client Action Simulator to test

### Testing Multi-Device

1. **Start Session**: Settings → House Session Manager → Start Hosting
2. **Add Devices**: Connected Devices → Simulate New Device
3. **Approve Devices**: Tap Approve on pending devices
4. **Assign Users**: Tap "Assign User" on connected devices
5. **Simulate Actions**: Client Action Simulator → Select device → Tap actions
6. **View Updates**: Return to Dashboard to see changes

---

## 🏆 Summary

HouseHarmony's multi-device architecture transforms household chore management into a collaborative, gamified experience. The Apple TV serves as the family's command center, while external devices enable individual participation. This prototype demonstrates the full concept with simulated networking, providing a foundation for real implementation.

**Built with ❤️ using SwiftUI and MVVM architecture**
