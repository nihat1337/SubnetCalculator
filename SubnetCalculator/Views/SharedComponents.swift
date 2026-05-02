//
//  SharedComponents.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

// MARK: - Glass Card

struct GlassCard<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .padding(16)
            .background(.white.opacity(0.055))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.09), lineWidth: 1)
            )
    }
}

// MARK: - Section Label

struct SectionLabel: View {
    let icon: String
    let text: String
    
    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 11, weight: .semibold))
            .tracking(1.2)
            .foregroundStyle(Color(red: 0, green: 0.9, blue: 1))
            .textCase(.uppercase)
    }
}

// MARK: - App Header

struct AppHeader: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: "network")
                    .font(.title)
                    .foregroundStyle(Color(red: 0, green: 0.9, blue: 1))
                
                Text(titleText)
            }
            
            Text("IP SUBNET DIVISION CALCULATOR")
                .font(.system(size: 10, weight: .semibold))
                .tracking(2)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(.top, 10)
    }
    
    private var titleText: AttributedString {
        var subnet = AttributedString("Subnet")
        subnet.font = .system(size: 28, weight: .black, design: .rounded)
        subnet.foregroundColor = .white
        
        var calc = AttributedString("Calc")
        calc.font = .system(size: 28, weight: .black, design: .rounded)
        calc.foregroundColor = Color(red: 0, green: 0.9, blue: 1)
        
        return subnet + calc
    }
}
