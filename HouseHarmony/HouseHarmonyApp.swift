//
//  HouseHarmonyApp.swift
//  HouseHarmony
//
//  Multi-user gamified household chore management app for tvOS
//

import SwiftUI

@main
struct HouseHarmonyApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
