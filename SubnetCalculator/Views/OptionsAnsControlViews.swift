//
//  OptionsAnsControlViews.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

// MARK: - Options Card

struct OptionsCard: View {
    @ObservedObject var viewModel: SubnetViewModel
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                // Division options
                divisionSection
                
                Divider()
                    .background(.white.opacity(0.08))
                
                // Execution mode
                executionModeSection
                
                executionModeDescription
            }
        }
    }
    
    // MARK: - Division Section
    
    private var divisionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(icon: "square.split.2x1", text: "Divide Into")
            
            HStack(spacing: 10) {
                ForEach(DivisionParts.allCases, id: \.self) { part in
                    SegmentButton(
                        label: part.label,
                        subtitle: "\(part.rawValue) subnets",
                        isSelected: viewModel.parts == part
                    ) {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.7)) {
                            viewModel.parts = part
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Execution Mode Section
    
    private var executionModeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(icon: "cpu", text: "Execution Mode")
            
            HStack(spacing: 10) {
                ForEach(ExecMode.allCases, id: \.self) { mode in
                    SegmentButton(
                        label: mode.rawValue,
                        subtitle: nil,
                        isSelected: viewModel.mode == mode
                    ) {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.7)) {
                            viewModel.mode = mode
                        }
                    }
                }
            }
        }
    }
    
    private var executionModeDescription: some View {
        HStack(spacing: 5) {
            Image(systemName: viewModel.mode.icon)
                .font(.caption2)
                .foregroundStyle(Color(red: 0, green: 0.9, blue: 1))
            
            Text(
                viewModel.mode == .sequential
                ? "Subnets appear one-by-one with animated progress."
                : "All subnets computed simultaneously via Swift TaskGroup."
            )
            .font(.system(size: 11))
            .foregroundStyle(.white.opacity(0.38))
        }
    }
}

// MARK: - Segment Button

struct SegmentButton: View {
    let label: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void
    
    private let accentColor = Color(red: 0, green: 0.9, blue: 1)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Text(label)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(isSelected ? .black : .white)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(
                            isSelected
                            ? .black.opacity(0.55)
                            : .white.opacity(0.38)
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(isSelected ? accentColor : .white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Calculate Button

struct CalcButton: View {
    @ObservedObject var viewModel: SubnetViewModel
    
    private let accentColor = Color(red: 0, green: 0.9, blue: 1)
    
    var body: some View {
        Button {
            viewModel.calculate()
        } label: {
            HStack(spacing: 9) {
                if viewModel.calculating {
                    ProgressView()
                        .tint(.black)
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .bold))
                }
                
                Text(viewModel.calculating ? "Calculating…" : "Calculate Subnets")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundStyle(
                viewModel.valid && !viewModel.calculating
                ? .black
                : .white.opacity(0.3)
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(
                viewModel.valid && !viewModel.calculating
                ? accentColor
                : .white.opacity(0.08)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: viewModel.valid ? accentColor.opacity(0.35) : .clear,
                radius: 12,
                y: 4
            )
        }
        .disabled(!viewModel.valid || viewModel.calculating)
        .animation(.easeInOut(duration: 0.2), value: viewModel.valid)
    }
}

// MARK: - Progress Card

struct ProgressCard: View {
    @ObservedObject var viewModel: SubnetViewModel
    
    private let accentColor = Color(red: 0, green: 0.9, blue: 1)
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Label(
                        viewModel.mode.rawValue + " Mode",
                        systemImage: viewModel.mode.icon
                    )
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    
                    Spacer()
                    
                    Text("\(currentProgress)/\(viewModel.parts.rawValue)")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundStyle(accentColor)
                }
                
                progressBar
            }
        }
    }
    
    private var currentProgress: Int {
        Int(viewModel.progress * Double(viewModel.parts.rawValue))
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.white.opacity(0.08))
                    .frame(height: 9)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            colors: [accentColor, accentColor.opacity(0.5)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * viewModel.progress, height: 9)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
            }
        }
        .frame(height: 9)
    }
}

// MARK: - Error Banner

struct ErrorBanner: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
            
            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.red.opacity(0.9))
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.red.opacity(0.25), lineWidth: 1)
        )
    }
}
