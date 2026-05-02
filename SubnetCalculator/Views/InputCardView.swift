//
//  InputCardView.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

// MARK: - Input Card

struct InputCard: View {
    @ObservedObject var viewModel: SubnetViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel(icon: "dot.radiowaves.left.and.right", text: "Network Address")
                
                // IP Field
                ipAddressField
                
                // CIDR Field
                cidrPrefixField
                
                // Live class badge
                if let cls = viewModel.liveClass() {
                    ClassBadge(cls: cls)
                }
            }
        }
        .onTapGesture {
            isFocused = false
        }
    }
    
    // MARK: - IP Address Field
    
    private var ipAddressField: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "globe")
                    .foregroundStyle(Color(red: 0, green: 0.9, blue: 1))
                    .frame(width: 20)
                
                TextField("e.g. 192.168.1.0", text: $viewModel.ip)
                    .keyboardType(.numbersAndPunctuation)
                    .font(.system(size: 17, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .focused($isFocused)
            }
            .padding(13)
            .background(.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            
            if !viewModel.ip.isEmpty && !viewModel.validIP(viewModel.ip) {
                Label("Invalid IP format", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
    
    // MARK: - CIDR Prefix Field
    
    private var cidrPrefixField: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("CIDR Prefix")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.45))
            
            HStack {
                Text("/")
                    .font(.system(size: 20, weight: .black, design: .monospaced))
                    .foregroundStyle(Color(red: 0, green: 0.9, blue: 1))
                
                TextField("24", text: $viewModel.cidrText)
                    .keyboardType(.numbersAndPunctuation)
                    .font(.system(size: 17, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .focused($isFocused)
                
                Spacer()
                
                CIDRBar(cidr: viewModel.cidrVal)
            }
            .padding(13)
            .background(.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            
            if viewModel.cidrVal >= 0 && viewModel.cidrVal <= 32 {
                let hostCount = viewModel.cidrVal < 31 ? (1 << (32 - viewModel.cidrVal)) - 2 : 0
                Text("≈ \(max(0, hostCount)) usable hosts")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.38))
            }
        }
    }
}

// MARK: - CIDR Bar

struct CIDRBar: View {
    let cidr: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<8, id: \.self) { i in
                let lo = i * 4
                let hi = (i + 1) * 4
                let fill: Double = cidr >= hi ? 1 : cidr > lo ? Double(cidr - lo) / 4 : 0
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        fill > 0
                        ? Color(red: 0, green: 0.9, blue: 1).opacity(0.4 + fill * 0.6)
                        : .white.opacity(0.1)
                    )
                    .frame(width: 8, height: 14)
            }
        }
    }
}

// MARK: - Class Badge

struct ClassBadge: View {
    let cls: IPClass
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(cls.color)
                .frame(width: 7, height: 7)
            
            Text(cls.rawValue)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(cls.color)
            
            Text("·")
                .foregroundStyle(.white.opacity(0.3))
            
            Text(cls.range)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.38))
                .lineLimit(1)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 5)
        .background(cls.color.opacity(0.12))
        .clipShape(Capsule())
    }
}
