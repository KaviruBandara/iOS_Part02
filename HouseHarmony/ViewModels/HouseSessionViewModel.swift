//
//  HouseSessionViewModel.swift
//  HouseHarmony
//
//  ViewModel for managing multi-device house session
//

import Foundation
import Combine
import SwiftUI

class HouseSessionViewModel: ObservableObject {
    @Published var session: HouseSession
    @Published var showPairingCode = false
    @Published var showDevicePermissions = false
    @Published var pendingDevice: DeviceModel?
    
    private let persistence = PersistenceService.shared
    
    init() {
        self.session = HouseSession()
        loadSession()
    }
    
    // MARK: - Session Management
    
    func startHosting() {
        session.isHosting = true
        session.pairingCode = HouseSession.generatePairingCode()
        session.startTime = Date()
        saveSession()
        
        // Log action
        addAction(
            deviceId: UUID(),
            deviceName: "TV Host",
            actionType: .connected,
            details: "Started hosting session"
        )
    }
    
    func stopHosting() {
        session.isHosting = false
        session.pairingCode = ""
        session.startTime = nil
        
        // Disconnect all devices
        for index in session.connectedDevices.indices {
            session.connectedDevices[index].status = .disconnected
        }
        
        saveSession()
        
        // Log action
        addAction(
            deviceId: UUID(),
            deviceName: "TV Host",
            actionType: .disconnected,
            details: "Stopped hosting session"
        )
    }
    
    func regeneratePairingCode() {
        session.pairingCode = HouseSession.generatePairingCode()
        saveSession()
    }
    
    // MARK: - Device Management
    
    func simulateNewDevice() {
        let deviceTypes = ["iPhone", "iPad"]
        let deviceNames = [
            "Emma's iPhone",
            "Mike's iPad",
            "Sarah's iPhone",
            "Alex's iPhone",
            "Guest Device"
        ]
        
        let newDevice = DeviceModel(
            name: deviceNames.randomElement() ?? "New Device",
            deviceType: deviceTypes.randomElement() ?? "iPhone",
            status: .pending,
            pairingCode: session.pairingCode
        )
        
        session.connectedDevices.append(newDevice)
        pendingDevice = newDevice
        showDevicePermissions = true
        saveSession()
        
        // Log action
        addAction(
            deviceId: newDevice.id,
            deviceName: newDevice.name,
            actionType: .connected,
            details: "Requesting to connect"
        )
    }
    
    func approveDevice(_ device: DeviceModel) {
        if let index = session.connectedDevices.firstIndex(where: { $0.id == device.id }) {
            session.connectedDevices[index].isApproved = true
            session.connectedDevices[index].status = .connected
            session.connectedDevices[index].connectionTime = Date()
            saveSession()
            
            // Log action
            addAction(
                deviceId: device.id,
                deviceName: device.name,
                actionType: .connected,
                details: "Device approved and connected"
            )
        }
    }
    
    func rejectDevice(_ device: DeviceModel) {
        session.connectedDevices.removeAll { $0.id == device.id }
        saveSession()
    }
    
    func blockDevice(_ device: DeviceModel) {
        if let index = session.connectedDevices.firstIndex(where: { $0.id == device.id }) {
            session.connectedDevices[index].isBlocked = true
            session.connectedDevices[index].status = .blocked
            saveSession()
        }
    }
    
    func disconnectDevice(_ device: DeviceModel) {
        if let index = session.connectedDevices.firstIndex(where: { $0.id == device.id }) {
            session.connectedDevices[index].status = .disconnected
            saveSession()
            
            // Log action
            addAction(
                deviceId: device.id,
                deviceName: device.name,
                actionType: .disconnected,
                details: "Device disconnected"
            )
        }
    }
    
    func assignDeviceToUser(_ device: DeviceModel, userId: UUID) {
        if let index = session.connectedDevices.firstIndex(where: { $0.id == device.id }) {
            session.connectedDevices[index].assignedUserId = userId
            saveSession()
        }
    }
    
    // MARK: - Simulated Actions
    
    func simulateClaimTask(device: DeviceModel, task: TaskModel, userName: String) {
        addAction(
            deviceId: device.id,
            deviceName: device.name,
            userId: device.assignedUserId,
            userName: userName,
            actionType: .claimedTask,
            details: "Claimed: \(task.title)"
        )
        updateDeviceActivity(device)
    }
    
    func simulateCompleteTask(device: DeviceModel, task: TaskModel, userName: String) {
        addAction(
            deviceId: device.id,
            deviceName: device.name,
            userId: device.assignedUserId,
            userName: userName,
            actionType: .completedTask,
            details: "Completed: \(task.title) (+\(task.points) pts)"
        )
        updateDeviceActivity(device)
    }
    
    func simulateCreateTask(device: DeviceModel, taskName: String, userName: String) {
        addAction(
            deviceId: device.id,
            deviceName: device.name,
            userId: device.assignedUserId,
            userName: userName,
            actionType: .createdTask,
            details: "Created: \(taskName)"
        )
        updateDeviceActivity(device)
    }
    
    func simulateAssignTask(device: DeviceModel, taskName: String, toUser: String, userName: String) {
        addAction(
            deviceId: device.id,
            deviceName: device.name,
            userId: device.assignedUserId,
            userName: userName,
            actionType: .assignedTask,
            details: "Assigned '\(taskName)' to \(toUser)"
        )
        updateDeviceActivity(device)
    }
    
    // MARK: - Helper Methods
    
    private func addAction(
        deviceId: UUID,
        deviceName: String,
        userId: UUID? = nil,
        userName: String? = nil,
        actionType: DeviceActionType,
        details: String
    ) {
        let action = DeviceAction(
            deviceId: deviceId,
            deviceName: deviceName,
            userId: userId,
            userName: userName,
            actionType: actionType,
            details: details
        )
        
        session.recentActions.insert(action, at: 0)
        
        // Keep only last 50 actions
        if session.recentActions.count > 50 {
            session.recentActions = Array(session.recentActions.prefix(50))
        }
        
        saveSession()
    }
    
    private func updateDeviceActivity(_ device: DeviceModel) {
        if let index = session.connectedDevices.firstIndex(where: { $0.id == device.id }) {
            session.connectedDevices[index].lastActivity = Date()
            saveSession()
        }
    }
    
    // MARK: - Persistence
    
    private func saveSession() {
        persistence.saveHouseSession(session)
    }
    
    private func loadSession() {
        session = persistence.loadHouseSession()
    }
    
    // MARK: - Sample Devices (for testing)
    
    func addSampleDevices() {
        let samples: [(String, String, UUID?)] = [
            ("Emma's iPhone", "iPhone", nil),
            ("Mike's iPad", "iPad", nil),
            ("Sarah's iPhone", "iPhone", nil),
            ("Alex's iPhone", "iPhone", nil)
        ]
        
        for (name, type, userId) in samples {
            let device = DeviceModel(
                name: name,
                deviceType: type,
                isApproved: true,
                assignedUserId: userId,
                status: .connected,
                connectionTime: Date()
            )
            session.connectedDevices.append(device)
        }
        
        saveSession()
    }
}
