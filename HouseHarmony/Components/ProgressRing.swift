//
//  ProgressRing.swift
//  HouseHarmony
//
//  Animated circular progress indicator
//

import SwiftUI

struct ProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat
    let color: Color
    let size: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        lineWidth: CGFloat = 12,
        color: Color = .blue,
        size: CGFloat = 120
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.color = color
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            // Center text
            VStack(spacing: 4) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(size: size * 0.25, weight: .bold))
                    .foregroundColor(color)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    HStack(spacing: 40) {
        ProgressRing(progress: 0.25, color: .blue, size: 150)
        ProgressRing(progress: 0.5, color: .green, size: 150)
        ProgressRing(progress: 0.75, color: .orange, size: 150)
        ProgressRing(progress: 1.0, color: .purple, size: 150)
    }
    .padding()
}
