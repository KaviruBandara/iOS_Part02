//
//  ConfettiView.swift
//  HouseHarmony
//
//  Confetti celebration animation
//

import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var rotation: Double
    var scale: CGFloat
    var color: Color
    var velocity: CGFloat
    var delay: Double
}

struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var isAnimating = false
    
    let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    Circle()
                        .fill(piece.color)
                        .frame(width: 10, height: 10)
                        .scaleEffect(piece.scale)
                        .rotationEffect(.degrees(piece.rotation))
                        .position(
                            x: piece.x,
                            y: isAnimating ? geometry.size.height + 50 : piece.y
                        )
                        .opacity(isAnimating ? 0 : 1)
                }
            }
            .onAppear {
                createConfetti(in: geometry.size)
                startAnimation()
            }
        }
        .allowsHitTesting(false)
    }
    
    private func createConfetti(in size: CGSize) {
        confettiPieces = (0..<100).map { index in
            ConfettiPiece(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: -200...0),
                rotation: Double.random(in: 0...360),
                scale: CGFloat.random(in: 0.5...1.5),
                color: colors.randomElement() ?? .blue,
                velocity: CGFloat.random(in: 300...600),
                delay: Double(index) * 0.01
            )
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 2.0)) {
            isAnimating = true
        }
    }
}

#Preview {
    ZStack {
        Color.black
        ConfettiView()
    }
}
