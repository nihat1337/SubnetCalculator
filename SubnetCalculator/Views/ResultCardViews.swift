//
//  ResultCardViews.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

// MARK: - Original Network Card

struct OriginalCard: View {
    @ObservedObject var viewModel: SubnetViewModel
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    SectionLabel(icon: "server.rack", text: "Original Network")
                    Spacer()
                    ClassBadge(cls: viewModel.ipClass)
                }
                
                Divider()
                    .background(.white.opacity(0.08))
                
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 10
                ) {
                    InfoCell(
                        label: "Network ID",
                        value: viewModel.origNetwork,
                        icon: "house.fill",
                        isAccent: true
                    )
                    InfoCell(
                        label: "Broadcast",
                        value: viewModel.origBroadcast,
                        icon: "megaphone.fill",
                        isAccent: false
                    )
                    InfoCell(
                        label: "Subnet Mask",
                        value: viewModel.origMask,
                        icon: "shield.fill",
                        isAccent: false
                    )
                    InfoCell(
                        label: "CIDR",
                        value: "/\(viewModel.origCIDR)",
                        icon: "number",
                        isAccent: false
                    )
                }
                
                HStack(spacing: 5) {
                    Image(systemName: "arrow.triangle.branch")
                        .font(.caption2)
                        .foregroundStyle(Color(red: 0, green: 0.9, blue: 1).opacity(0.7))
                    
                    Text("Split into \(viewModel.parts.rawValue) subnets · \(viewModel.mode.rawValue) execution")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.38))
                }
            }
        }
    }
}

// MARK: - Subnet Result Card

struct SubnetCard: View {
    let subnet: SubnetResult
    let delay: Double
    
    @State private var isExpanded = false
    @State private var isVisible = false
    
    private let accentColor = Color(red: 0, green: 0.9, blue: 1)
    
    var body: some View {
        GlassCard {
            VStack(spacing: 0) {
                // Header row — always visible
                headerButton
                
                // Expanded detail
                if isExpanded {
                    Divider()
                        .background(.white.opacity(0.08))
                        .padding(.vertical, 12)
                    
                    detailGrid
                    
                    addressSpaceBar
                }
            }
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 18)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isVisible = true
                }
            }
        }
    }
    
    // MARK: - Header Button
    
    private var headerButton: some View {
        Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.75)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                indexBadge
                
                subnetInfo
                
                Spacer()
                
                usableHostsCount
                
                chevronIcon
            }
        }
        .buttonStyle(.plain)
    }
    
    private var indexBadge: some View {
        ZStack {
            Circle()
                .fill(accentColor.opacity(0.15))
                .frame(width: 36, height: 36)
            
            Text("\(subnet.index)")
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(accentColor)
        }
    }
    
    private var subnetInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Subnet \(subnet.index)")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
            
            Text("\(subnet.network)\(subnet.cidr)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(accentColor.opacity(0.8))
        }
    }
    
    private var usableHostsCount: some View {
        VStack(alignment: .trailing, spacing: 1) {
            Text("\(subnet.usable)")
                .font(.system(size: 17, weight: .black))
                .foregroundStyle(.white)
            
            Text("usable hosts")
                .font(.system(size: 9))
                .foregroundStyle(.white.opacity(0.4))
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.white.opacity(0.35))
    }
    
    // MARK: - Detail Grid
    
    private var detailGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 10
        ) {
            InfoCell(
                label: "Network ID",
                value: subnet.network,
                icon: "house.fill",
                isAccent: true
            )
            InfoCell(
                label: "Broadcast",
                value: subnet.broadcast,
                icon: "megaphone.fill",
                isAccent: false
            )
            InfoCell(
                label: "First Host",
                value: subnet.firstHost,
                icon: "arrow.right.circle",
                isAccent: false
            )
            InfoCell(
                label: "Last Host",
                value: subnet.lastHost,
                icon: "arrow.left.circle",
                isAccent: false
            )
            InfoCell(
                label: "Subnet Mask",
                value: subnet.mask,
                icon: "shield.fill",
                isAccent: false
            )
            InfoCell(
                label: "CIDR",
                value: subnet.cidr,
                icon: "number",
                isAccent: false
            )
        }
    }
    
    // MARK: - Address Space Bar
    
    private var addressSpaceBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ADDRESS SPACE")
                .font(.system(size: 9, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.3))
            
            HStack(spacing: 0) {
                RangeBlock(
                    label: "Net",
                    color: .orange,
                    width: 34
                )
                
                RangeBlock(
                    label: "\(subnet.usable) hosts · \(subnet.firstHost) → \(subnet.lastHost)",
                    color: accentColor,
                    width: nil
                )
                
                RangeBlock(
                    label: "Bcast",
                    color: .red,
                    width: 40
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(.top, 8)
    }
}

// MARK: - Range Block

struct RangeBlock: View {
    let label: String
    let color: Color
    let width: CGFloat?
    
    var body: some View {
        Text(label)
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(color)
            .frame(maxWidth: width ?? .infinity)
            .frame(height: 22)
            .background(color.opacity(0.18))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }
}

// MARK: - Info Cell

struct InfoCell: View {
    let label: String
    let value: String
    let icon: String
    let isAccent: Bool
    
    private let accentColor = Color(red: 0, green: 0.9, blue: 1)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 9))
                    .foregroundStyle(isAccent ? accentColor : .white.opacity(0.35))
                
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.white.opacity(0.38))
            }
            
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(isAccent ? accentColor : .white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
