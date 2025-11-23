//
//  ClientActionSimulatorScreen.swift
//  HouseHarmony
//
//  Simulator for client device actions
//

import SwiftUI

struct ClientActionSimulatorScreen: View {
    @ObservedObject var sessionViewModel: HouseSessionViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedDevice: DeviceModel?
    @State private var selectedTask: TaskModel?
    @State private var selectedUser: UserModel?
    
    var connectedDevices: [DeviceModel] {
        sessionViewModel.session.connectedDevices.filter { $0.status == .connected }
    }
    
    var availableTasks: [TaskModel] {
        appState.choreCategories.flatMap { $0.tasks }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.oceanGradient.ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header
                HStack(spacing: 12) {
                    BackButton { dismiss() }
                    Spacer()
                    Image("HouseHarmony")
                        .resizable().scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("Client Action Simulator")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 60).padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Device Selection
                        if !connectedDevices.isEmpty {
                            DeviceSelector(devices: connectedDevices, selectedDevice: $selectedDevice)
                        } else {
                            EmptyStateCard(message: "No connected devices")
                        }
                        
                        if let device = selectedDevice {
                            // Action Buttons
                            SimActionButton(
                                title: "Claim Random Task",
                                icon: "hand.raised.fill",
                                color: .accentOrange
                            ) {
                                if let task = availableTasks.randomElement(),
                                   let user = getUserForDevice(device),
                                   let category = appState.choreCategories.first(where: { $0.tasks.contains(where: { $0.id == task.id }) }) {
                                    sessionViewModel.simulateClaimTask(device: device, task: task, userName: user.name)
                                    appState.claimTask(task, in: category.id)
                                }
                            }
                            
                            SimActionButton(
                                title: "Complete Random Task",
                                icon: "checkmark.circle.fill",
                                color: .accentGreen
                            ) {
                                if let task = availableTasks.filter({ $0.isClaimed }).randomElement(),
                                   let user = getUserForDevice(device),
                                   let category = appState.choreCategories.first(where: { $0.tasks.contains(where: { $0.id == task.id }) }) {
                                    sessionViewModel.simulateCompleteTask(device: device, task: task, userName: user.name)
                                    appState.completeTask(task, in: category.id)
                                }
                            }
                            
                            SimActionButton(
                                title: "Create Task",
                                icon: "plus.circle.fill",
                                color: .accentCyan
                            ) {
                                if let user = getUserForDevice(device) {
                                    sessionViewModel.simulateCreateTask(device: device, taskName: "New Task", userName: user.name)
                                }
                            }
                            
                            SimActionButton(
                                title: "Assign Task to User",
                                icon: "arrow.right.circle.fill",
                                color: .accentPurple
                            ) {
                                if let task = availableTasks.randomElement(),
                                   let toUser = appState.users.randomElement(),
                                   let user = getUserForDevice(device) {
                                    sessionViewModel.simulateAssignTask(device: device, taskName: task.title, toUser: toUser.name, userName: user.name)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60).padding(.vertical, 20)
                }
            }
        }
    }
    
    private func getUserForDevice(_ device: DeviceModel) -> UserModel? {
        if let userId = device.assignedUserId {
            return appState.users.first { $0.id == userId }
        }
        return appState.users.first
    }
}

struct DeviceSelector: View {
    let devices: [DeviceModel]
    @Binding var selectedDevice: DeviceModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Device")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(devices) { device in
                        DeviceSelectorCard(
                            device: device,
                            isSelected: selectedDevice?.id == device.id
                        ) {
                            selectedDevice = device
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.glassBorder, lineWidth: 1.5)
        )
        .onAppear {
            if selectedDevice == nil {
                selectedDevice = devices.first
            }
        }
    }
}

struct DeviceSelectorCard: View {
    let device: DeviceModel
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: device.deviceIcon)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .accentCyan : .white.opacity(0.7))
                
                Text(device.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 150, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.accentCyan.opacity(0.2) : Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isSelected ? Color.accentCyan : (isFocused ? Color.white.opacity(0.6) : Color.clear),
                        lineWidth: isSelected ? 2 : (isFocused ? 2 : 0)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct SimActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 20, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.glassHeavy)
                    .background(RoundedRectangle(cornerRadius: 20).fill(LinearGradient(colors: [
                        color.opacity(isFocused ? 0.35 : 0.2),
                        color.opacity(isFocused ? 0.15 : 0.05)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)))
            )
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(isFocused ? color.opacity(0.8) : Color.glassBorder, lineWidth: isFocused ? 3 : 1.5))
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(color: isFocused ? color.opacity(0.6) : .black.opacity(0.3), radius: isFocused ? 30 : 15)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

struct EmptyStateCard: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.accentYellow)
            
            Text(message)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.glassBorder, lineWidth: 1.5)
        )
    }
}
