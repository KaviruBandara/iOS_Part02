//
//  LeaderboardScreen.swift
//  HouseHarmony
//
//  Leaderboard rankings screen
//

import SwiftUI

struct LeaderboardScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPeriod: LeaderboardPeriod = .allTime
    
    var leaderboardEntries: [LeaderboardEntry] {
        appState.getLeaderboard(period: selectedPeriod)
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header
                HStack(spacing: 20) {
                    Text("🏆")
                        .font(.system(size: 50))
                    
                    Text("Leaderboard")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Period badge
                    Text(selectedPeriod.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            Capsule()
                                .stroke(Color.glassBorder, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 60)
                .padding(.top, 20)
                
                // Podium (Top 3)
                if leaderboardEntries.count >= 3 {
                    PodiumView(
                        first: leaderboardEntries[0],
                        second: leaderboardEntries[1],
                        third: leaderboardEntries[2]
                    )
                    .padding(.horizontal, 60)
                }
                
                // Full Rankings
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(leaderboardEntries) { entry in
                            LeaderboardRow(
                                entry: entry,
                                isHighlighted: entry.userId == appState.currentUser?.id
                            )
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 15)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// MARK: - Podium View
struct PodiumView: View {
    let first: LeaderboardEntry
    let second: LeaderboardEntry
    let third: LeaderboardEntry
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 25) {
            // Second Place
            PodiumCard(entry: second, height: 200, rank: 2)
            
            // First Place
            PodiumCard(entry: first, height: 260, rank: 1)
            
            // Third Place
            PodiumCard(entry: third, height: 170, rank: 3)
        }
        .padding(.vertical, 15)
    }
}

// MARK: - Podium Card
struct PodiumCard: View {
    let entry: LeaderboardEntry
    let height: CGFloat
    let rank: Int
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
                // Trophy
                Text(entry.rankEmoji)
                    .font(.system(size: rank == 1 ? 70 : 55))
                
                // Avatar
                AvatarView(
                    avatar: entry.userAvatar,
                    color: entry.color,
                    size: rank == 1 ? 100 : 80,
                    showBorder: true
                )
                
                // User Info
                VStack(spacing: 6) {
                    Text(entry.userName)
                        .font(.system(size: rank == 1 ? 22 : 18, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.accentYellow)
                        
                        Text("\(entry.points)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: 240)
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .frame(width: 280, height: height)
            .padding(.top, 15)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.glassHeavy)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        isFocused ? entry.color.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.08 : 1.0)
            .shadow(
                color: isFocused ? entry.color.opacity(0.4) : Color.clear,
                radius: 20
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusable(true)
        .focusEffectDisabled()
    }
}

#Preview {
    LeaderboardScreen()
        .environmentObject(AppState())
}
