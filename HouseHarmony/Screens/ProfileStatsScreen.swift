//
//  ProfileStatsScreen.swift
//  HouseHarmony
//
//  User profile and statistics screen
//

import SwiftUI

struct ProfileStatsScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showAdminPanel = false
    
    var userBadges: [BadgeModel] {
        guard let user = appState.currentUser else { return [] }
        return BadgeModel.allBadges.map { badge in
            var updatedBadge = badge
            updatedBadge.isUnlocked = user.badgesEarned.contains(badge.id)
            return updatedBadge
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                if let user = appState.currentUser {
                    // Header - Ultra Compact
                    HStack(spacing: 10) {
                        // Avatar image - minimal
                        ZStack {
                            Circle()
                                .fill(user.color.opacity(0.2))
                                .frame(width: 35, height: 35)
                            
                            Image(user.avatar)
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .clipped()
                                .clipShape(Circle())
                            
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [user.color.opacity(0.8), user.color.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                                .frame(width: 35, height: 35)
                        }
                        
                        Text("\(user.name)'s Profile")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Level badge - minimal
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.accentYellow)
                            
                            Text("Lv \(user.level)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.accentYellow.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 10)
                    
                    // Scrollable Content
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            // Admin Panel Button (only for admin users)
                            if user.isAdmin {
                                AdminPanelButton {
                                    showAdminPanel = true
                                }
                            }
                            
                            // Quick Stats
                            QuickStatsView(user: user)
                            
                            // Stats Grid
                            StatsGrid(user: user)
                            
                            // Level Progress
                            LevelProgressView(user: user)
                            
                            // Badges
                            BadgesSection(badges: userBadges)
                            
                            // Logout Button
                            LogoutButton {
                                appState.currentUser = nil
                                appState.showProfileSelection = true
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showAdminPanel) {
            AdminManagementScreen()
                .environmentObject(appState)
        }
    }
}

// MARK: - Admin Panel Button
struct AdminPanelButton: View {
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.accentPurple.opacity(0.3), Color.accentPurple.opacity(0.1), Color.clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .fill(Color.glassHeavy)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.accentPurple.opacity(0.6), lineWidth: 2)
                        )
                    
                    Image(systemName: "gear.badge.checkmark")
                        .font(.system(size: 28))
                        .foregroundColor(.accentPurple)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Admin Panel")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Manage categories, tasks, and assignments")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.glassHeavy)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        isFocused ? Color.accentPurple.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.accentPurple.opacity(0.5) : Color.black.opacity(0.2),
                radius: isFocused ? 25 : 10
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Quick Stats View
struct QuickStatsView: View {
    let user: UserModel
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 20) {
            // Avatar with glow
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [user.color.opacity(0.4), user.color.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Circle()
                    .fill(user.color.opacity(0.2))
                    .frame(width: 140, height: 140)
                
                Image(user.avatar)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipped()
                    .clipShape(Circle())
                
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [user.color.opacity(0.8), user.color.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 140, height: 140)
            }
            
            Spacer()
            
            // Quick stats pills
            VStack(spacing: 15) {
                HStack(spacing: 15) {
                    QuickStatPill(
                        icon: "star.fill",
                        label: "Points",
                        value: "\(user.totalPoints)",
                        color: .accentYellow
                    )
                    
                    QuickStatPill(
                        icon: "checkmark.circle.fill",
                        label: "Tasks",
                        value: "\(user.tasksCompleted)",
                        color: .accentGreen
                    )
                }
                
                HStack(spacing: 15) {
                    QuickStatPill(
                        icon: "flame.fill",
                        label: "Streak",
                        value: "\(user.currentStreak)",
                        color: .accentOrange
                    )
                    
                    QuickStatPill(
                        icon: "trophy.fill",
                        label: "Badges",
                        value: "\(user.badgesEarned.count)",
                        color: user.color
                    )
                }
            }
        }
        .padding(.horizontal, 35)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    isFocused ? user.color.opacity(0.8) : Color.glassBorder,
                    lineWidth: isFocused ? 3 : 1.5
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(
            color: isFocused ? user.color.opacity(0.4) : Color.black.opacity(0.2),
            radius: isFocused ? 20 : 10
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}

// MARK: - Quick Stat Pill
struct QuickStatPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Stats Grid
struct StatsGrid: View {
    let user: UserModel
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 25),
                GridItem(.flexible(), spacing: 25),
                GridItem(.flexible(), spacing: 25)
            ],
            spacing: 25
        ) {
            StatCard(
                title: "Tasks Completed",
                value: "\(user.tasksCompleted)",
                icon: "checkmark.circle.fill",
                color: .accentGreen
            )
            
            StatCard(
                title: "Total Points",
                value: "\(user.totalPoints)",
                icon: "star.fill",
                color: .accentYellow
            )
            
            StatCard(
                title: "Current Streak",
                value: "\(user.currentStreak)",
                icon: "flame.fill",
                color: .accentOrange
            )
            
            StatCard(
                title: "Longest Streak",
                value: "\(user.longestStreak)",
                icon: "chart.line.uptrend.xyaxis",
                color: .accentCyan
            )
            
            StatCard(
                title: "Badges Earned",
                value: "\(user.badgesEarned.count)",
                icon: "trophy.fill",
                color: user.color
            )
            
            StatCard(
                title: "Current Level",
                value: "\(user.level)",
                icon: "crown.fill",
                color: .accentPurple
            )
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 18) {
            // Icon with glow - same style as category cards
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.3), color.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 25,
                            endRadius: 55
                        )
                    )
                    .frame(width: 110, height: 110)
                
                Circle()
                    .fill(Color.glassHeavy)
                    .frame(width: 85, height: 85)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.5), lineWidth: 2)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 38))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    isFocused ? color.opacity(0.8) : Color.glassBorder,
                    lineWidth: isFocused ? 3 : 1.5
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(
            color: isFocused ? color.opacity(0.6) : Color.black.opacity(0.3),
            radius: isFocused ? 30 : 15
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}

// MARK: - Level Progress
struct LevelProgressView: View {
    let user: UserModel
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 20) {
            HStack {
                Text("Level Progress")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Level \(user.level) → \(user.level + 1)")
                    .font(.headline)
                    .foregroundColor(user.color)
            }
            
            ProgressRing(
                progress: user.progressToNextLevel,
                lineWidth: 20,
                color: user.color,
                size: 200
            )
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    isFocused ? user.color.opacity(0.8) : Color.glassBorder,
                    lineWidth: isFocused ? 3 : 1.5
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(
            color: isFocused ? user.color.opacity(0.4) : Color.black.opacity(0.2),
            radius: isFocused ? 20 : 10
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}

// MARK: - Badges Section
struct BadgesSection: View {
    let badges: [BadgeModel]
    @Environment(\.isFocused) var isFocused
    
    var unlockedBadges: [BadgeModel] {
        badges.filter { $0.isUnlocked }
    }
    
    var lockedBadges: [BadgeModel] {
        badges.filter { !$0.isUnlocked }
    }
    
    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 25) {
            Text("Badges")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if !unlockedBadges.isEmpty {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Unlocked (\(unlockedBadges.count))")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 20
                    ) {
                        ForEach(unlockedBadges) { badge in
                            BadgeChip(badge: badge, size: 100, showTitle: true)
                        }
                    }
                }
            }
            
            if !lockedBadges.isEmpty {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Locked (\(lockedBadges.count))")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 20
                    ) {
                        ForEach(lockedBadges.prefix(10)) { badge in
                            BadgeChip(badge: badge, size: 100, showTitle: true)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    isFocused ? Color.accentPurple.opacity(0.8) : Color.glassBorder,
                    lineWidth: isFocused ? 3 : 1.5
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(
            color: isFocused ? Color.accentPurple.opacity(0.4) : Color.black.opacity(0.2),
            radius: isFocused ? 20 : 10
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}

// MARK: - Logout Button
struct LogoutButton: View {
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Logout")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
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
                                        Color.userRed.opacity(isFocused ? 0.4 : 0.2),
                                        Color.userRed.opacity(isFocused ? 0.2 : 0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isFocused ? Color.userRed.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 2.5 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.userRed.opacity(0.5) : Color.black.opacity(0.2),
                radius: isFocused ? 25 : 10
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

#Preview {
    ProfileStatsScreen()
        .environmentObject(AppState())
}
