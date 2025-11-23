//
//  ProfileSelectionScreen.swift
//  HouseHarmony
//
//  User profile selection screen
//

import SwiftUI

struct ProfileSelectionScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Background gradient - same as category page
            LinearGradient.oceanGradient
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header - Ultra Compact
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Image("HouseHarmony")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                        
                        Text("HouseHarmony")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                    
                    Text("Choose Your Profile")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
                .padding(.top, 12)
                
                // User Grid - Single horizontal row (Full Screen)
                HStack(spacing: 25) {
                    ForEach(appState.users) { user in
                        ProfileCard(user: user) {
                            appState.selectUser(user)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            }
        }
    }
}

// MARK: - Profile Card
struct ProfileCard: View {
    let user: UserModel
    let action: () -> Void
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 25) {
                // Avatar with glow - LARGER
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [user.color.opacity(0.4), user.color.opacity(0.1), Color.clear],
                                center: .center,
                                startRadius: 80,
                                endRadius: 160
                            )
                        )
                        .frame(width: 320, height: 320)
                    
                    Circle()
                        .fill(user.color.opacity(0.2))
                        .frame(width: 220, height: 220)
                    
                    Image(user.avatar)
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 220, height: 220)
                        .clipped()
                        .clipShape(Circle())
                    
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [user.color.opacity(0.8), user.color.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 220, height: 220)
                }
                
                VStack(spacing: 10) {
                    // Name - LARGER
                    Text(user.name)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    // Admin badge
                    if user.isAdmin {
                        Text("Admins")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.accentPurple)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.accentPurple.opacity(0.2))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.accentPurple.opacity(0.5), lineWidth: 1.5)
                            )
                    }
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.accentYellow)
                            Text("\(user.totalPoints)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.accentOrange)
                            Text("\(user.currentStreak)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 16))
                                .foregroundColor(user.color)
                            Text("Lv.\(user.level)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 35)
            .frame(height: 550)
            .frame(width: 380)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.glassHeavy)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        user.color.opacity(isFocused ? 0.35 : 0.2),
                                        user.color.opacity(isFocused ? 0.15 : 0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
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
                color: isFocused ? user.color.opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 30 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

// MARK: - Add User Card
struct AddUserCard: View {
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button {
            // Add new user action
        } label: {
            VStack(spacing: 20) {
                // Plus icon with glow
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.2), Color.white.opacity(0.05), Color.clear],
                                center: .center,
                                startRadius: 50,
                                endRadius: 90
                            )
                        )
                        .frame(width: 180, height: 180)
                    
                    Circle()
                        .fill(Color.glassLight)
                        .frame(width: 130, height: 130)
                        .overlay(
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.4),
                                    style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                                )
                        )
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("Add User")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .frame(height: 340)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.glassLight)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        isFocused ? Color.glassBorderFocused : Color.white.opacity(0.3),
                        style: StrokeStyle(lineWidth: isFocused ? 3 : 1.5, dash: [10, 5])
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.white.opacity(0.3) : Color.black.opacity(0.2),
                radius: isFocused ? 25 : 15
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.card)
        .focusEffectDisabled()
    }
}

#Preview {
    ProfileSelectionScreen()
        .environmentObject(AppState())
}
