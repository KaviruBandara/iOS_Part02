//
//  ColorExtension.swift
//  HouseHarmony
//
//  Hex color support for SwiftUI
//

import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        let r, g, b, a: Double
        
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    // MARK: - Glassmorphism Theme
    
    // Background Gradients
    static let gradientStart = Color(hex: "#0F2027") ?? .black
    static let gradientMiddle = Color(hex: "#203A43") ?? .gray
    static let gradientEnd = Color(hex: "#2C5364") ?? .blue
    
    // Alternative gradient
    static let gradientPurpleStart = Color(hex: "#1A1A2E") ?? .black
    static let gradientPurpleEnd = Color(hex: "#16213E") ?? .blue
    
    // Glass surfaces - Dark theme with subtle tint
    static let glassLight = Color(hex: "#1A2332") ?? Color.black.opacity(0.3)
    static let glassMedium = Color(hex: "#1F2937") ?? Color.black.opacity(0.4)
    static let glassHeavy = Color(hex: "#243447") ?? Color.black.opacity(0.5)
    static let glassUltra = Color(hex: "#2A3F5F") ?? Color.black.opacity(0.6)
    
    // Glass borders
    static let glassBorder = Color.white.opacity(0.3)
    static let glassBorderFocused = Color.white.opacity(0.6)
    
    // Vibrant accent colors
    static let accentCyan = Color(hex: "#00D9FF") ?? .cyan
    static let accentPurple = Color(hex: "#A855F7") ?? .purple
    static let accentPink = Color(hex: "#EC4899") ?? .pink
    static let accentGreen = Color(hex: "#10B981") ?? .green
    static let accentYellow = Color(hex: "#FBBF24") ?? .yellow
    static let accentOrange = Color(hex: "#F97316") ?? .orange
    
    // User theme colors (vibrant)
    static let userRed = Color(hex: "#EF4444") ?? .red
    static let userBlue = Color(hex: "#3B82F6") ?? .blue
    static let userGreen = Color(hex: "#10B981") ?? .green
    static let userYellow = Color(hex: "#FBBF24") ?? .yellow
    static let userPurple = Color(hex: "#A855F7") ?? .purple
    static let userPink = Color(hex: "#EC4899") ?? .pink
    static let userCyan = Color(hex: "#06B6D4") ?? .cyan
    static let userOrange = Color(hex: "#F97316") ?? .orange
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let oceanGradient = LinearGradient(
        colors: [Color.gradientStart, Color.gradientMiddle, Color.gradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let nightGradient = LinearGradient(
        colors: [Color.gradientPurpleStart, Color.gradientPurpleEnd],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let glassShimmer = LinearGradient(
        colors: [
            Color.white.opacity(0.0),
            Color.white.opacity(0.1),
            Color.white.opacity(0.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Glass Material Modifier
struct GlassMaterial: ViewModifier {
    var opacity: Double = 0.15
    var blur: CGFloat = 20
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.glassHeavy)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.glassBorder, lineWidth: 1)
            )
    }
}

// MARK: - Modern Hover Effect Modifier
struct ModernHoverEffect: ViewModifier {
    let color: Color
    let isFocused: Bool
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                color.opacity(isFocused ? 0.25 : 0.08),
                                color.opacity(isFocused ? 0.12 : 0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        isFocused ? color.opacity(0.8) : Color.glassBorder,
                        lineWidth: isFocused ? 3 : 1.5
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? color.opacity(0.5) : Color.black.opacity(0.3),
                radius: isFocused ? 25 : 10
            )
            .brightness(isFocused ? 0.1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

extension View {
    func glassMaterial(
        opacity: Double = 0.15,
        blur: CGFloat = 20,
        cornerRadius: CGFloat = 20
    ) -> some View {
        modifier(GlassMaterial(opacity: opacity, blur: blur, cornerRadius: cornerRadius))
    }
}
