//
//  AvatarView.swift
//  HouseHarmony
//
//  User avatar display component
//

import SwiftUI

struct AvatarView: View {
    let avatar: String
    let color: Color
    let size: CGFloat
    var showBorder: Bool = true
    
    init(
        avatar: String,
        color: Color,
        size: CGFloat = 80,
        showBorder: Bool = true
    ) {
        self.avatar = avatar
        self.color = color
        self.size = size
        self.showBorder = showBorder
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size, height: size)
            
            // Avatar image from assets
            Image(avatar)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipped()
                .clipShape(Circle())
            
            // Border with gradient
            if showBorder {
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [color.opacity(0.8), color.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: size, height: size)
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        AvatarView(
            avatar: "👨‍🎓",
            color: .blue,
            size: 100
        )
        
        AvatarView(
            avatar: "👩‍💼",
            color: .pink,
            size: 80
        )
        
        AvatarView(
            avatar: "👧",
            color: .green,
            size: 60,
            showBorder: false
        )
    }
    .padding()
}
