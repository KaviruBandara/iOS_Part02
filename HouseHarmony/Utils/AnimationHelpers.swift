//
//  AnimationHelpers.swift
//  HouseHarmony
//
//  Animation utilities and custom transitions
//

import SwiftUI

// MARK: - Custom Animations
extension Animation {
    static let smooth = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let snappy = Animation.spring(response: 0.2, dampingFraction: 0.8)
}

// MARK: - Focus Effects
struct FocusScaleEffect: ViewModifier {
    @Environment(\.isFocused) var isFocused
    var scale: CGFloat = 1.05
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isFocused ? scale : 1.0)
            .animation(.smooth, value: isFocused)
    }
}

struct FocusBorderEffect: ViewModifier {
    @Environment(\.isFocused) var isFocused
    var color: Color = .white
    var width: CGFloat = 4
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color, lineWidth: isFocused ? width : 0)
                    .animation(.smooth, value: isFocused)
            )
    }
}

struct FocusShadowEffect: ViewModifier {
    @Environment(\.isFocused) var isFocused
    var color: Color = .white
    var radius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .shadow(color: isFocused ? color.opacity(0.6) : .clear, radius: radius)
            .animation(.smooth, value: isFocused)
    }
}

extension View {
    func focusScale(_ scale: CGFloat = 1.05) -> some View {
        modifier(FocusScaleEffect(scale: scale))
    }
    
    func focusBorder(color: Color = .white, width: CGFloat = 4) -> some View {
        modifier(FocusBorderEffect(color: color, width: width))
    }
    
    func focusShadow(color: Color = .white, radius: CGFloat = 20) -> some View {
        modifier(FocusShadowEffect(color: color, radius: radius))
    }
    
    func tvOSCard() -> some View {
        self
            .focusScale(1.08)
            .focusBorder()
            .focusShadow()
    }
}

// MARK: - Shake Animation
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {
    func shake(with value: Int) -> some View {
        modifier(ShakeEffect(animatableData: CGFloat(value)))
    }
}

// MARK: - Pulse Animation
struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    var minScale: CGFloat = 0.95
    var maxScale: CGFloat = 1.05
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .animation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func pulse(minScale: CGFloat = 0.95, maxScale: CGFloat = 1.05) -> some View {
        modifier(PulseEffect(minScale: minScale, maxScale: maxScale))
    }
}
