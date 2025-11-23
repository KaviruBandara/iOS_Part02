//
//  ContentView.swift
//  HouseHarmony
//
//  Main navigation container
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showWelcome = true
    
    var body: some View {
        ZStack {
            Color(hex: "#1A1A2E")
                .ignoresSafeArea()
            
            if showWelcome {
                WelcomeScreen()
                    .onAppear {
                        // Auto-dismiss welcome after user interaction
                        // The welcome screen handles navigation to profile selection
                    }
            } else if appState.showProfileSelection || appState.currentUser == nil {
                ProfileSelectionScreen()
            } else {
                DashboardScreen()
            }
        }
        .animation(.smooth, value: showWelcome)
        .animation(.smooth, value: appState.showProfileSelection)
        .animation(.smooth, value: appState.currentUser)
        .onAppear {
            // Always show welcome screen on app startup
            showWelcome = true
        }
        .onChange(of: appState.currentUser) {
            if appState.currentUser != nil {
                showWelcome = false
                UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
