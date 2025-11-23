//
//  BackButton.swift
//  HouseHarmony
//
//  Styled back button component
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    @Environment(\.isFocused) var isFocused
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                Text("Back")
                    .font(.system(size: 20, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.glassHeavy)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(isFocused ? 0.25 : 0.08),
                                        Color.white.opacity(isFocused ? 0.12 : 0.03)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        isFocused ? Color.white.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.white.opacity(0.5) : Color.black.opacity(0.2),
                radius: isFocused ? 25 : 10
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        LinearGradient.oceanGradient
            .ignoresSafeArea()
        
        BackButton {
            print("Back tapped")
        }
    }
}
