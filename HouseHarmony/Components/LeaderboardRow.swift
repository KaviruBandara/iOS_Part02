//
//  LeaderboardRow.swift
//  HouseHarmony
//
//  Leaderboard entry row component
//

import SwiftUI

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    var isHighlighted: Bool = false
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 18) {
            // Rank emoji
            Text(entry.rankEmoji)
                .font(.system(size: 40))
                .frame(width: 60)
            
            // Avatar
            AvatarView(
                avatar: entry.userAvatar,
                color: entry.color,
                size: 70,
                showBorder: true
            )
            
            // User Info
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.userName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                HStack(spacing: 15) {
                    // Points
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.accentYellow)
                        Text("\(entry.points)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    
                    // Tasks
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.accentGreen)
                        Text("\(entry.tasksCompleted)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(1)
                    }
                    
                    // Streak
                    if entry.streak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.accentOrange)
                            Text("\(entry.streak)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(1)
                        }
                    }
                }
            }
            
            Spacer(minLength: 10)
            
            // Rank Number
            Text("#\(entry.rank)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(entry.color)
                .frame(width: 80)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.glassHeavy)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    isFocused ? entry.color.opacity(0.8) : (isHighlighted ? entry.color.opacity(0.5) : Color.glassBorder),
                    lineWidth: isFocused ? 3 : (isHighlighted ? 2 : 1)
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(
            color: isFocused ? entry.color.opacity(0.5) : Color.black.opacity(0.2),
            radius: isFocused ? 25 : 10
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}

#Preview {
    VStack(spacing: 20) {
        LeaderboardRow(
            entry: LeaderboardEntry(
                userId: UUID(),
                userName: "Emma",
                userAvatar: "👧",
                userColor: "#A8E6CF",
                rank: 1,
                points: 890,
                tasksCompleted: 89,
                streak: 21,
                badgeCount: 6
            ),
            isHighlighted: true
        )
        
        LeaderboardRow(
            entry: LeaderboardEntry(
                userId: UUID(),
                userName: "Alex",
                userAvatar: "👨‍🎓",
                userColor: "#FF6B6B",
                rank: 2,
                points: 450,
                tasksCompleted: 45,
                streak: 7,
                badgeCount: 3
            )
        )
    }
    .padding()
}
