//
//  FocusableCard.swift
//  HouseHarmony
//
//  Reusable focusable card component for tvOS
//

import SwiftUI

struct FocusableCard<Content: View>: View {
    let content: Content
    var backgroundColor: Color = Color(hex: "#16213E") ?? .gray
    var cornerRadius: CGFloat = 20
    
    @Environment(\.isFocused) var isFocused
    
    init(
        backgroundColor: Color = Color(hex: "#16213E") ?? .gray,
        cornerRadius: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isFocused ? Color.white : Color.clear, lineWidth: 4)
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? Color.white.opacity(0.4) : .clear,
                radius: isFocused ? 20 : 0
            )
            .animation(.smooth, value: isFocused)
    }
}

#Preview {
    FocusableCard {
        VStack {
            Text("Sample Card")
                .font(.title)
            Text("This is a focusable card")
                .font(.body)
        }
    }
    .frame(width: 400, height: 300)
}
