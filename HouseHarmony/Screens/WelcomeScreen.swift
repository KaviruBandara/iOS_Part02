//
//  WelcomeScreen.swift
//  HouseHarmony
//
//  Welcome screen shown on app launch
//

import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var showProfiles = false
    
    var body: some View {
        ZStack {
            // Background gradient - Darker for better logo visibility
            LinearGradient(
                colors: [
                    Color(hex: "#0A1520") ?? .black,
                    Color(hex: "#152535") ?? .black,
                    Color(hex: "#1A3A4A") ?? .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                // App Logo and Title
                VStack(spacing: 25) {
                    // Animated house icon
                    ZStack {
                        // Outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.accentCyan.opacity(0.4),
                                        Color.accentCyan.opacity(0.2),
                                        Color.accentCyan.opacity(0.05),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 150,
                                    endRadius: 350
                                )
                            )
                            .frame(width: 600, height: 600)
                        
                        // Bright background circle for logo
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.95),
                                        Color.white.opacity(0.85)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 450, height: 450)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.accentCyan,
                                                Color.accentCyan.opacity(0.7)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 4
                                    )
                            )
                            .shadow(color: Color.accentCyan.opacity(0.6), radius: 40)
                        
                        Image("HouseHarmony")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 420, height: 420)
                    }
                    
                    // App name
                    Text("HouseHarmony")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Tagline
                    Text("Making household chores fun for everyone")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 100)
                }
                
                Spacer()
                
                // Get Started Button
                Button {
                    showProfiles = true
                } label: {
                    HStack(spacing: 15) {
                        Text("Get Started")
                            .font(.system(size: 28, weight: .bold))
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 28))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 25)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentCyan, Color.accentCyan.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: Color.accentCyan.opacity(0.5), radius: 30)
                }
                .buttonStyle(.card)
                .focusEffectDisabled()
                
                Spacer()
                    .frame(height: 80)
            }
        }
        .fullScreenCover(isPresented: $showProfiles) {
            ProfileSelectionScreen()
                .environmentObject(appState)
        }
    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(AppState())
}
