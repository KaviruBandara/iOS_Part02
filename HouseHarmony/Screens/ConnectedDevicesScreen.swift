//
//  ConnectedDevicesScreen.swift
//  HouseHarmony
//
//  Screen for viewing and managing connected devices
//

import SwiftUI

struct ConnectedDevicesScreen: View {
    @ObservedObject var sessionViewModel: HouseSessionViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showAssignDevice: DeviceModel?
    
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
                    Text("Connected Devices")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 60).padding(.top, 10)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Add Device Button
                        AddDeviceButton {
                            sessionViewModel.simulateNewDevice()
                        }
                        
                        // Device List
                        ForEach(sessionViewModel.session.connectedDevices) { device in
                            DeviceCard(
                                device: device,
                                onApprove: { sessionViewModel.approveDevice(device) },
                                onReject: { sessionViewModel.rejectDevice(device) },
                                onBlock: { sessionViewModel.blockDevice(device) },
                                onDisconnect: { sessionViewModel.disconnectDevice(device) },
                                onAssign: { showAssignDevice = device }
                            )
                        }
                    }
                    .padding(.horizontal, 60).padding(.vertical, 20)
                }
            }
        }
        .sheet(item: $showAssignDevice) { device in
            AssignDeviceSheet(device: device, users: appState.users) { userId in
                sessionViewModel.assignDeviceToUser(device, userId: userId)
                showAssignDevice = nil
            }
        }
    }
}

struct AddDeviceButton: View {
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                Text("Simulate New Device Connecting")
                    .font(.system(size: 20, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.glassHeavy)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(colors: [
                                Color.accentGreen.opacity(isFocused ? 0.35 : 0.2),
                                Color.accentGreen.opacity(isFocused ? 0.15 : 0.05)
                            ], startPoint: .top, endPoint: .bottom))
                    )
            )
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(isFocused ? Color.accentGreen.opacity(0.8) : Color.glassBorder, lineWidth: isFocused ? 3 : 1.5))
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(color: isFocused ? Color.accentGreen.opacity(0.6) : .black.opacity(0.3), radius: isFocused ? 30 : 15)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

struct DeviceCard: View {
    let device: DeviceModel
    let onApprove: () -> Void
    let onReject: () -> Void
    let onBlock: () -> Void
    let onDisconnect: () -> Void
    let onAssign: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 15) {
                HStack(spacing: 20) {
                    // Device Icon
                    ZStack {
                        Circle()
                            .fill(RadialGradient(colors: [device.statusColor.opacity(0.3), .clear], center: .center, startRadius: 20, endRadius: 50))
                            .frame(width: 100, height: 100)
                        Circle()
                            .fill(Color.glassHeavy)
                            .frame(width: 70, height: 70)
                        Image(systemName: device.deviceIcon)
                            .font(.system(size: 30))
                            .foregroundColor(device.statusColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(device.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 10) {
                            Image(systemName: device.statusIcon)
                                .font(.system(size: 14))
                            Text(device.status.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(device.statusColor)
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .background(Capsule().fill(device.statusColor.opacity(0.2)))
                        
                        if let connectionTime = device.connectionTime {
                            Text("Connected: \(connectionTime.formatted(date: .omitted, time: .shortened))")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                }
                
                // Action Buttons
                if device.status == .pending {
                    HStack(spacing: 12) {
                        SmallActionButton(title: "Approve", icon: "checkmark", color: .accentGreen, action: onApprove)
                        SmallActionButton(title: "Reject", icon: "xmark", color: .userRed, action: onReject)
                    }
                } else if device.status == .connected {
                    HStack(spacing: 12) {
                        SmallActionButton(title: "Assign User", icon: "person.fill", color: .accentCyan, action: onAssign)
                        SmallActionButton(title: "Disconnect", icon: "link.badge.minus", color: .accentOrange, action: onDisconnect)
                        SmallActionButton(title: "Block", icon: "hand.raised", color: .userRed, action: onBlock)
                    }
                }
            }
            .padding(25)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
                .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(colors: [
                    device.statusColor.opacity(isFocused ? 0.35 : 0.15),
                    device.statusColor.opacity(isFocused ? 0.15 : 0.05)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)))
        )
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(isFocused ? device.statusColor.opacity(0.8) : Color.glassBorder, lineWidth: isFocused ? 3 : 1.5))
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(color: isFocused ? device.statusColor.opacity(0.6) : .black.opacity(0.3), radius: isFocused ? 30 : 15)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        .buttonStyle(.plain)
    }
}

struct SmallActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 14))
                Text(title).font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.3)))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.6), lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

struct AssignDeviceSheet: View {
    let device: DeviceModel
    let users: [UserModel]
    let onAssign: (UUID) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient.oceanGradient.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Assign Device to User")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text(device.name)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.7))
                
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(users) { user in
                            Button {
                                onAssign(user.id)
                            } label: {
                                HStack {
                                    AvatarView(avatar: user.avatar, color: user.color, size: 50, showBorder: true)
                                    Text(user.name)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color.glassHeavy))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(40)
                }
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.white)
                .padding()
            }
            .padding(40)
        }
    }
}
