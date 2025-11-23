//
//  BadgeChip.swift
//  HouseHarmony
//
//  Badge display component
//

import SwiftUI

struct BadgeChip: View {
    let badge: BadgeModel
    var size: CGFloat = 80
    var showTitle: Bool = true
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        badge.isUnlocked
                            ? badge.color.opacity(0.2)
                            : Color.gray.opacity(0.1)
                    )
                    .frame(width: size, height: size)
                
                Circle()
                    .strokeBorder(
                        badge.isUnlocked ? badge.color : Color.gray,
                        lineWidth: 3
                    )
                    .frame(width: size, height: size)
                
                Image(systemName: badge.icon)
                    .font(.system(size: size * 0.4))
                    .foregroundColor(badge.isUnlocked ? badge.color : .gray)
                
                if !badge.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: size * 0.2))
                        .foregroundColor(.gray)
                        .offset(x: size * 0.25, y: size * 0.25)
                }
            }
            
            if showTitle {
                VStack(spacing: 2) {
                    Text(badge.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(badge.isUnlocked ? .primary : .gray)
                    
                    Text(badge.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(width: size * 1.5)
            }
        }
        .opacity(badge.isUnlocked ? 1.0 : 0.5)
    }
}

#Preview {
    HStack(spacing: 30) {
        BadgeChip(
            badge: BadgeModel(
                id: "test1",
                name: "First Steps",
                description: "Complete your first task",
                icon: "star.fill",
                type: .milestone,
                requirement: 1,
                colorHex: "#FFD700",
                isUnlocked: true
            ),
            size: 100
        )
        
        BadgeChip(
            badge: BadgeModel(
                id: "test2",
                name: "Locked Badge",
                description: "This badge is locked",
                icon: "crown.fill",
                type: .milestone,
                requirement: 100,
                colorHex: "#FF6B6B",
                isUnlocked: false
            ),
            size: 100
        )
    }
    .padding()
}
