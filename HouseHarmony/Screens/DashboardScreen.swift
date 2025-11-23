//
//  DashboardScreen.swift
//  HouseHarmony
//
//  Main dashboard home screen
//

import SwiftUI

struct DashboardScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: DashboardTab = .chores
    
    enum DashboardTab {
        case chores, leaderboard, profile, settings
    }
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header - 50% smaller padding
                DashboardHeader()
                    .padding(.horizontal, 60)
                    .padding(.top, 12)
                    .padding(.bottom, 10)
                
                // Content
                TabView(selection: $selectedTab) {
                    ChoresScreen()
                        .tag(DashboardTab.chores)
                    
                    LeaderboardScreen()
                        .tag(DashboardTab.leaderboard)
                    
                    ProfileStatsScreen()
                        .tag(DashboardTab.profile)
                    
                    SettingsScreen()
                        .tag(DashboardTab.settings)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation Bar - 50% smaller padding
                DashboardNavigationBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 10)
            }
            .allowsHitTesting(!appState.showTaskCompletion)
            
            // Task Completion Celebration - Full screen overlay
            if appState.showTaskCompletion, let task = appState.completedTask {
                TaskCompletionView(
                    task: task,
                    userColor: appState.currentUser?.color ?? .blue,
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            appState.showTaskCompletion = false
                            appState.completedTask = nil
                        }
                    }
                )
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.showTaskCompletion)
    }
}

// MARK: - Dashboard Header
struct DashboardHeader: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 20) {
            // Logo - Ultra Compact
            HStack(spacing: 8) {
                Image("HouseHarmony")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text("HouseHarmony")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            Spacer(minLength: 20)
            
            // User Info
            if let user = appState.currentUser {
                HStack(spacing: 20) {
                    VStack(alignment: .trailing, spacing: 8) {
                        // Name with admin badge
                        HStack(spacing: 8) {
                            if user.isAdmin {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.accentPurple)
                                    Text("Admin")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.accentPurple)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.accentPurple.opacity(0.2))
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(Color.accentPurple.opacity(0.5), lineWidth: 1)
                                )
                            }
                            
                            Text(user.name)
                                .font(.system(size: user.isAdmin ? 28 : 22, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        
                        HStack(spacing: 12) {
                            // Points
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.accentYellow)
                                Text("\(user.totalPoints)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            
                            // Level
                            HStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(user.color)
                                Text("Lv.\(user.level)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            
                            // Streak
                            if user.currentStreak > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.accentOrange)
                                    Text("\(user.currentStreak)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    
                    // Enhanced avatar for admin
                    ZStack {
                        if user.isAdmin {
                            // Glow effect for admin
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [user.color.opacity(0.4), user.color.opacity(0.1), Color.clear],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)
                        }
                        
                        AvatarView(
                            avatar: user.avatar,
                            color: user.color,
                            size: user.isAdmin ? 45 : 40,
                            showBorder: true
                        )
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.glassHeavy)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.glassBorder, lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Navigation Bar
struct DashboardNavigationBar: View {
    @Binding var selectedTab: DashboardScreen.DashboardTab
    
    var body: some View {
        HStack(spacing: 30) {
            NavButton(
                icon: "house.fill",
                title: "Chores",
                isSelected: selectedTab == .chores
            ) {
                selectedTab = .chores
            }
            
            NavButton(
                icon: "trophy.fill",
                title: "Leaderboard",
                isSelected: selectedTab == .leaderboard
            ) {
                selectedTab = .leaderboard
            }
            
            NavButton(
                icon: "person.fill",
                title: "Profile",
                isSelected: selectedTab == .profile
            ) {
                selectedTab = .profile
            }
            
            NavButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == .settings
            ) {
                selectedTab = .settings
            }
        }
        .padding(9)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.glassBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 20)
    }
}

// MARK: - Nav Button
struct NavButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 130, height: 65)
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color.glassUltra : Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isFocused ? Color.accentCyan.opacity(0.8) : (isSelected ? Color.glassBorder : Color.clear),
                        lineWidth: isFocused ? 3 : (isSelected ? 1.5 : 0)
                    )
            )
            .scaleEffect(isFocused ? 1.08 : 1.0)
            .shadow(
                color: isFocused ? Color.accentCyan.opacity(0.4) : Color.clear,
                radius: 20
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

#Preview {
    DashboardScreen()
        .environmentObject(AppState())
}
