//
//  SettingsScreen.swift
//  HouseHarmony
//
//  App settings and options screen
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetConfirmation = false
    @State private var showHouseSession = false
    
    var body: some View {
        ZStack {
            // Background gradient - same as category page
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header
                HStack(spacing: 15) {
                    Text("⚙️")
                        .font(.system(size: 45))
                    
                    Text("Settings")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // User Section
                        SettingsSection(title: "Account") {
                            SettingsButton(
                                title: "Switch Profile",
                                icon: "person.2.fill",
                                color: .accentCyan
                            ) {
                                appState.logoutCurrentUser()
                            }
                        }
                        
                        // Multi-Device Section
                        SettingsSection(title: "Multi-Device") {
                            SettingsButton(
                                title: "House Session Manager",
                                icon: "antenna.radiowaves.left.and.right",
                                color: .accentPurple
                            ) {
                                showHouseSession = true
                            }
                        }
                        
                        // Data Section
                        SettingsSection(title: "Data") {
                            SettingsButton(
                                title: "Reset Daily Tasks",
                                icon: "arrow.clockwise.circle.fill",
                                color: .accentOrange
                            ) {
                                _ = PersistenceService.shared.checkAndPerformDailyReset()
                            }
                            
                            SettingsButton(
                                title: "Reset All Data",
                                icon: "trash.circle.fill",
                                color: .userRed
                            ) {
                                showResetConfirmation = true
                            }
                        }
                        
                        // App Info
                        SettingsSection(title: "About") {
                            InfoRow(label: "Version", value: "1.0.0")
                            InfoRow(label: "Platform", value: "tvOS")
                            InfoRow(label: "Build", value: "2024.1")
                        }
                        
                        // Credits
                        VStack(spacing: 10) {
                            HStack(spacing: 8) {
                                Image("HouseHarmony")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                
                                Text("HouseHarmony")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Making household chores fun for everyone")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Reset All Data", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                PersistenceService.shared.resetToDefaults()
                appState.loadData()
            }
        } message: {
            Text("This will delete all user data and restore default values. This action cannot be undone.")
        }
        .fullScreenCover(isPresented: $showHouseSession) {
            HouseSessionHostScreen()
                .environmentObject(appState)
        }
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                content
            }
        }
    }
}

// MARK: - Settings Button
struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon with glow
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [color.opacity(0.3), color.opacity(0.1), Color.clear],
                                center: .center,
                                startRadius: 15,
                                endRadius: 35
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Circle()
                        .fill(Color.glassHeavy)
                        .frame(width: 55, height: 55)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.5), lineWidth: 2)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.glassHeavy)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        color.opacity(isFocused ? 0.25 : 0.15),
                                        color.opacity(isFocused ? 0.12 : 0.05)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isFocused ? color.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(
                color: isFocused ? color.opacity(0.5) : Color.black.opacity(0.2),
                radius: isFocused ? 25 : 10
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.glassLight)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.glassBorder.opacity(0.5), lineWidth: 1)
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.white.opacity(0.1)),
            alignment: .bottom
        )
    }
}

#Preview {
    SettingsScreen()
        .environmentObject(AppState())
}
