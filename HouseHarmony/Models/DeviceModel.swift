//
//  DeviceModel.swift
//  HouseHarmony
//
//  Device model for multi-device session management
//

import Foundation
import SwiftUI

// MARK: - Device Connection Status
enum DeviceStatus: String, Codable {
    case connected = "Connected"
    case disconnected = "Disconnected"
    case pending = "Pending Approval"
    case blocked = "Blocked"
}

// MARK: - Device Model
struct DeviceModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var deviceType: String // "iPhone", "iPad"
    var isApproved: Bool
    var isBlocked: Bool
    var assignedUserId: UUID?
    var status: DeviceStatus
    var connectionTime: Date?
    var lastActivity: Date?
    var pairingCode: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        deviceType: String,
        isApproved: Bool = false,
        isBlocked: Bool = false,
        assignedUserId: UUID? = nil,
        status: DeviceStatus = .pending,
        connectionTime: Date? = nil,
        lastActivity: Date? = nil,
        pairingCode: String? = nil
    ) {
        self.id = id
        self.name = name
        self.deviceType = deviceType
        self.isApproved = isApproved
        self.isBlocked = isBlocked
        self.assignedUserId = assignedUserId
        self.status = status
        self.connectionTime = connectionTime
        self.lastActivity = lastActivity
        self.pairingCode = pairingCode
    }
    
    var statusColor: Color {
        switch status {
        case .connected:
            return .accentGreen
        case .disconnected:
            return .gray
        case .pending:
            return .accentYellow
        case .blocked:
            return .userRed
        }
    }
    
    var statusIcon: String {
        switch status {
        case .connected:
            return "checkmark.circle.fill"
        case .disconnected:
            return "xmark.circle.fill"
        case .pending:
            return "clock.fill"
        case .blocked:
            return "hand.raised.fill"
        }
    }
    
    var deviceIcon: String {
        switch deviceType {
        case "iPhone":
            return "iphone"
        case "iPad":
            return "ipad"
        default:
            return "apps.iphone"
        }
    }
}

// MARK: - Device Action
struct DeviceAction: Identifiable, Codable {
    let id: UUID
    let deviceId: UUID
    let deviceName: String
    let userId: UUID?
    let userName: String?
    let actionType: DeviceActionType
    let timestamp: Date
    var details: String
    
    init(
        id: UUID = UUID(),
        deviceId: UUID,
        deviceName: String,
        userId: UUID? = nil,
        userName: String? = nil,
        actionType: DeviceActionType,
        timestamp: Date = Date(),
        details: String = ""
    ) {
        self.id = id
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.userId = userId
        self.userName = userName
        self.actionType = actionType
        self.timestamp = timestamp
        self.details = details
    }
    
    var actionIcon: String {
        switch actionType {
        case .claimedTask:
            return "hand.raised.fill"
        case .completedTask:
            return "checkmark.circle.fill"
        case .createdTask:
            return "plus.circle.fill"
        case .assignedTask:
            return "arrow.right.circle.fill"
        case .connected:
            return "link.circle.fill"
        case .disconnected:
            return "link.circle.badge.xmark"
        }
    }
    
    var actionColor: Color {
        switch actionType {
        case .claimedTask:
            return .accentOrange
        case .completedTask:
            return .accentGreen
        case .createdTask:
            return .accentCyan
        case .assignedTask:
            return .accentPurple
        case .connected:
            return .accentGreen
        case .disconnected:
            return .gray
        }
    }
}

// MARK: - Device Action Type
enum DeviceActionType: String, Codable {
    case claimedTask = "Claimed Task"
    case completedTask = "Completed Task"
    case createdTask = "Created Task"
    case assignedTask = "Assigned Task"
    case connected = "Connected"
    case disconnected = "Disconnected"
}

// MARK: - House Session
struct HouseSession: Codable {
    var householdId: String
    var householdName: String
    var isHosting: Bool
    var pairingCode: String
    var startTime: Date?
    var connectedDevices: [DeviceModel]
    var recentActions: [DeviceAction]
    
    init(
        householdId: String = "BandaraHome",
        householdName: String = "Bandara Family",
        isHosting: Bool = false,
        pairingCode: String = "",
        startTime: Date? = nil,
        connectedDevices: [DeviceModel] = [],
        recentActions: [DeviceAction] = []
    ) {
        self.householdId = householdId
        self.householdName = householdName
        self.isHosting = isHosting
        self.pairingCode = pairingCode
        self.startTime = startTime
        self.connectedDevices = connectedDevices
        self.recentActions = recentActions
    }
    
    var connectedCount: Int {
        connectedDevices.filter { $0.status == .connected }.count
    }
    
    var pendingCount: Int {
        connectedDevices.filter { $0.status == .pending }.count
    }
    
    static func generatePairingCode() -> String {
        let digits = (1000...9999).randomElement() ?? 1234
        return String(digits)
    }
}
