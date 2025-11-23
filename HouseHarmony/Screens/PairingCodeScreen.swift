//
//  PairingCodeScreen.swift
//  HouseHarmony
//
//  Display pairing code for device connection
//

import SwiftUI

struct PairingCodeScreen: View {
    let pairingCode: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient.oceanGradient.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 15) {
                    Image("HouseHarmony")
                        .resizable().scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    Text("Connect Your Device")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Enter this code on your device")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Pairing Code Display
                HStack(spacing: 30) {
                    ForEach(Array(pairingCode.enumerated()), id: \.offset) { index, digit in
                        Text(String(digit))
                            .font(.system(size: 90, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 140, height: 160)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.glassHeavy)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(LinearGradient(
                                                colors: [Color.accentCyan.opacity(0.3), Color.accentPurple.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.accentCyan.opacity(0.6), lineWidth: 3)
                            )
                            .shadow(color: Color.accentCyan.opacity(0.5), radius: 30)
                    }
                }
                
                // Instructions
                VStack(spacing: 15) {
                    InstructionRow(number: 1, text: "Open HouseHarmony app on your device")
                    InstructionRow(number: 2, text: "Tap 'Connect to TV'")
                    InstructionRow(number: 3, text: "Enter the 4-digit code shown above")
                }
                .padding(.horizontal, 60)
                
                Spacer()
                
                // Close Button
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.glassHeavy)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.glassBorder, lineWidth: 1.5)
                        )
                }
                .buttonStyle(.card)
            }
            .padding(60)
        }
    }
}

struct InstructionRow: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text("\(number)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.accentCyan)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.glassHeavy))
                .overlay(Circle().stroke(Color.accentCyan.opacity(0.6), lineWidth: 2))
            
            Text(text)
                .font(.system(size: 18))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    PairingCodeScreen(pairingCode: "1234")
}
