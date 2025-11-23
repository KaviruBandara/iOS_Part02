//
//  HouseSessionHostScreen.swift
//  HouseHarmony
//
//  Main screen for managing house hosting session
//

import SwiftUI

struct HouseSessionHostScreen: View {
    @StateObject private var sessionViewModel = HouseSessionViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showDevicesScreen = false
    @State private var showPairingCode = false
    @State private var showSimulator = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Ocean gradient background
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header
                HStack(spacing: 12) {
                    BackButton {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Image("HouseHarmony")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("House Session")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 60)
                .padding(.top, 10)
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Session Status Card
                        SessionStatusCard(session: sessionViewModel.session)
                        
                        // Control Buttons
                        if !sessionViewModel.session.isHosting {
                            StartHostingButton {
                                sessionViewModel.startHosting()
                            }
                        } else {
                            VStack(spacing: 15) {
                                // Pairing Code Button
                                PairingCodeButton {
                                    showPairingCode = true
                                }
                                
                                // Connected Devices Button
                                DevicesButton(count: sessionViewModel.session.connectedCount) {
                                    showDevicesScreen = true
                                }
                                
                                // Simulator Button
                                SimulatorButton {
                                    showSimulator = true
                                }
                                
                                // Stop Hosting Button
                                StopHostingButton {
                                    sessionViewModel.stopHosting()
                                }
                            }
                        }
                        
                        // Recent Actions Feed
                        if !sessionViewModel.session.recentActions.isEmpty {
                            RecentActionsFeed(actions: Array(sessionViewModel.session.recentActions.prefix(5)))
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.vertical, 20)
                }
            }
        }
        .fullScreenCover(isPresented: $showDevicesScreen) {
            ConnectedDevicesScreen(sessionViewModel: sessionViewModel)
                .environmentObject(appState)
        }
        .fullScreenCover(isPresented: $showPairingCode) {
            PairingCodeScreen(pairingCode: sessionViewModel.session.pairingCode)
        }
        .fullScreenCover(isPresented: $showSimulator) {
            ClientActionSimulatorScreen(sessionViewModel: sessionViewModel)
                .environmentObject(appState)
        }
    }
}

// MARK: - Session Status Card
struct SessionStatusCard: View {
    let session: HouseSession
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 20) {
            // Household Info
            VStack(spacing: 10) {
                Image(systemName: "house.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.accentCyan)
                
                Text(session.householdName)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("ID: \(session.householdId)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Status
            HStack(spacing: 30) {
                StatusPill(
                    icon: session.isHosting ? "antenna.radiowaves.left.and.right" : "moon.zzz.fill",
                    label: session.isHosting ? "Hosting" : "Offline",
                    color: session.isHosting ? .accentGreen : .gray
                )
                
                if session.isHosting {
                    StatusPill(
                        icon: "apps.iphone",
                        label: "\(session.connectedCount) Connected",
                        color: .accentCyan
                    )
                    
                    if session.pendingCount > 0 {
                        StatusPill(
                            icon: "clock.fill",
                            label: "\(session.pendingCount) Pending",
                            color: .accentYellow
                        )
                    }
                }
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.accentCyan.opacity(isFocused ? 0.35 : 0.2),
                                    Color.accentCyan.opacity(isFocused ? 0.15 : 0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    isFocused ? Color.accentCyan.opacity(0.8) : Color.glassBorder,
                    lineWidth: isFocused ? 3 : 1.5
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(
            color: isFocused ? Color.accentCyan.opacity(0.6) : Color.black.opacity(0.3),
            radius: isFocused ? 30 : 15
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusable(true)
        .focusEffectDisabled()
    }
}

// MARK: - Status Pill
struct StatusPill: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(label)
                .font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(color)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(color.opacity(0.2))
        )
        .overlay(
            Capsule()
                .stroke(color.opacity(0.5), lineWidth: 1.5)
        )
    }
}

// MARK: - Action Buttons
struct StartHostingButton: View {
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 24, weight: .semibold))
                Text("Start Hosting Session")
                    .font(.system(size: 24, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 25)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.glassHeavy)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.accentGreen.opacity(isFocused ? 0.35 : 0.2),
                                        Color.accentGreen.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isFocused ? Color.accentGreen.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.accentGreen.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

struct PairingCodeButton: View {
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "qrcode")
                    .font(.system(size: 20, weight: .semibold))
                Text("Show Pairing Code")
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
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.accentPurple.opacity(isFocused ? 0.35 : 0.2),
                                        Color.accentPurple.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isFocused ? Color.accentPurple.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.accentPurple.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

struct DevicesButton: View {
    let count: Int
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "apps.iphone")
                    .font(.system(size: 20, weight: .semibold))
                Text("Connected Devices (\(count))")
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
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.accentCyan.opacity(isFocused ? 0.35 : 0.2),
                                        Color.accentCyan.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isFocused ? Color.accentCyan.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.accentCyan.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

struct SimulatorButton: View {
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 20, weight: .semibold))
                Text("Client Action Simulator")
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
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.accentYellow.opacity(isFocused ? 0.35 : 0.2),
                                        Color.accentYellow.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isFocused ? Color.accentYellow.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.accentYellow.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

struct StopHostingButton: View {
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 20, weight: .semibold))
                Text("Stop Hosting")
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
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.userRed.opacity(isFocused ? 0.35 : 0.2),
                                        Color.userRed.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isFocused ? Color.userRed.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.userRed.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Recent Actions Feed
struct RecentActionsFeed: View {
    let actions: [DeviceAction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            VStack(spacing: 12) {
                ForEach(actions) { action in
                    ActionRow(action: action)
                }
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
    }
}

struct ActionRow: View {
    let action: DeviceAction
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: action.actionIcon)
                .font(.system(size: 16))
                .foregroundColor(action.actionColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(action.details)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    if let userName = action.userName {
                        Text(userName)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Text(action.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.glassLight)
        )
    }
}

#Preview {
    HouseSessionHostScreen()
        .environmentObject(AppState())
}
