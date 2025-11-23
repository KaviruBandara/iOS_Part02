//
//  TaskCard.swift
//  HouseHarmony
//
//  Individual task card component
//

import SwiftUI

struct TaskCard: View {
    let task: TaskModel
    let categoryColor: Color
    var onClaim: (() -> Void)?
    var onComplete: (() -> Void)?
    
    @Environment(\.isFocused) var isFocused
    @State private var justClaimed = false
    @State private var claimScale: CGFloat = 1.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                // Task Title
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    if !task.description.isEmpty {
                        Text(task.description)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                            .minimumScaleFactor(0.9)
                    }
                }
                
                Spacer()
                
                // Points Badge
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.accentYellow)
                    Text("\(task.points)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.glassHeavy)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.accentYellow.opacity(0.3), Color.accentYellow.opacity(0.1)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(Color.accentYellow.opacity(0.5), lineWidth: 1.5)
                )
            }
            
            // Task Metadata
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: priorityIcon(task.priority))
                        .font(.system(size: 12))
                    Text(task.priority.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(priorityColor(task.priority))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(priorityColor(task.priority).opacity(0.2))
                )
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                    Text(task.frequency.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.glassLight)
                )
                
                Spacer()
                
                if task.isCompleted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                        Text("Completed")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.accentGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.accentGreen.opacity(0.2))
                    )
                } else if task.isClaimed || justClaimed {
                    HStack(spacing: 4) {
                        Image(systemName: justClaimed ? "hand.raised.fill" : "person.fill")
                            .font(.system(size: 12))
                        Text("Claimed")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.accentOrange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.accentOrange.opacity(0.2))
                    )
                    .scaleEffect(justClaimed ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: justClaimed)
                }
            }
            
            // Action Buttons
            if !task.isCompleted {
                HStack(spacing: 12) {
                    if !task.isClaimed && !justClaimed {
                        Button {
                            // Trigger animation
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                claimScale = 1.2
                            }
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.1)) {
                                claimScale = 1.0
                            }
                            
                            // Show claimed state immediately
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    justClaimed = true
                                }
                            }
                            
                            // Call the actual claim handler
                            onClaim?()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "hand.raised.fill")
                                    .font(.system(size: 16))
                                Text("Claim Task")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        LinearGradient(
                                            colors: [categoryColor, categoryColor.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                            )
                            .scaleEffect(claimScale)
                        }
                        .buttonStyle(.card)
                    } else {
                        Button {
                            onComplete?()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                Text("Complete")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.accentGreen, Color.accentGreen.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.card)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.glassHeavy)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            LinearGradient(
                                colors: [
                                    categoryColor.opacity(isFocused ? 0.25 : 0.15),
                                    categoryColor.opacity(isFocused ? 0.12 : 0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    isFocused ? categoryColor.opacity(0.8) : Color.glassBorder,
                    lineWidth: isFocused ? 3 : 1.5
                )
        )
        .scaleEffect(isFocused ? 1.02 : 1.0)
        .shadow(
            color: isFocused ? categoryColor.opacity(0.5) : Color.black.opacity(0.2),
            radius: isFocused ? 25 : 10
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
    
    private func priorityIcon(_ priority: TaskPriority) -> String {
        switch priority {
        case .low: return "arrow.down.circle.fill"
        case .medium: return "circle.fill"
        case .high: return "arrow.up.circle.fill"
        }
    }
    
    private func priorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TaskCard(
            task: TaskModel(
                title: "Wash dishes",
                description: "Clean all dishes from sink and dishwasher",
                points: 15,
                category: "Kitchen",
                priority: .medium
            ),
            categoryColor: .red,
            onClaim: {},
            onComplete: {}
        )
        
        TaskCard(
            task: TaskModel(
                title: "Vacuum living room",
                description: "Vacuum entire living room carpet",
                points: 20,
                category: "Living Room",
                priority: .high,
                isCompleted: true
            ),
            categoryColor: .blue
        )
    }
    .frame(width: 600)
    .padding()
}
