//
//  TaskCompletionView.swift
//  HouseHarmony
//
//  Celebration screen shown after task completion
//

import SwiftUI

struct TaskCompletionView: View {
    let task: TaskModel
    let userColor: Color
    let onDismiss: () -> Void
    
    @State private var showConfetti = false
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = -180
    @State private var contentOpacity: Double = 0.0
    @FocusState private var isButtonFocused: Bool
    
    var body: some View {
        ZStack {
            // Dark gradient overlay - Full screen background
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.95),
                    Color.gradientStart.opacity(0.9),
                    Color.black.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Confetti
            if showConfetti {
                ConfettiView()
            }
            
            // Content Card
            VStack(spacing: 35) {
                // Success Icon
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [userColor.opacity(0.4), userColor.opacity(0.1), Color.clear],
                                center: .center,
                                startRadius: 50,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                    
                    Circle()
                        .fill(Color.glassHeavy)
                        .frame(width: 220, height: 220)
                        .overlay(
                            Circle()
                                .stroke(userColor.opacity(0.6), lineWidth: 3)
                        )
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 140))
                        .foregroundColor(userColor)
                        .rotationEffect(.degrees(rotation))
                }
                .scaleEffect(scale)
                
                // Message
                VStack(spacing: 12) {
                    Text("Task Completed!")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(task.title)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 600)
                    
                    // Points Earned
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.accentYellow)
                        
                        Text("+\(task.points)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.accentYellow)
                            .lineLimit(1)
                        
                        Text("points")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        Capsule()
                            .fill(Color.glassHeavy)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.accentYellow.opacity(0.4), lineWidth: 2)
                    )
                    .padding(.top, 15)
                }
                
                // Continue Button
                Button {
                    onDismiss()
                } label: {
                    Text("Continue")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(width: 280, height: 65)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(
                                    LinearGradient(
                                        colors: [userColor, userColor.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(
                                    isButtonFocused ? Color.white.opacity(0.8) : Color.white.opacity(0.3),
                                    lineWidth: isButtonFocused ? 4 : 2
                                )
                        )
                        .scaleEffect(isButtonFocused ? 1.1 : 1.0)
                        .shadow(color: userColor.opacity(isButtonFocused ? 0.8 : 0.5), radius: isButtonFocused ? 30 : 20)
                        .animation(.easeInOut(duration: 0.2), value: isButtonFocused)
                }
                .buttonStyle(.card)
                .focused($isButtonFocused)
                .padding(.top, 15)
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 40)
            .opacity(contentOpacity)
        }
        .onAppear {
            // Fade in content immediately
            withAnimation(.easeOut(duration: 0.25)) {
                contentOpacity = 1.0
            }
            
            // Animate entrance with smoother spring
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                scale = 1.0
                rotation = 0
            }
            
            // Show confetti after slight delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                showConfetti = true
            }
            
            // Set focus to Continue button after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isButtonFocused = true
            }
        }
    }
}

#Preview {
    TaskCompletionView(
        task: TaskModel(
            title: "Wash dishes",
            points: 15,
            category: "Kitchen"
        ),
        userColor: .blue,
        onDismiss: {}
    )
}
