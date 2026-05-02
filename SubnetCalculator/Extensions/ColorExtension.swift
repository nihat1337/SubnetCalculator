//
//  ColorExtension.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

// MARK: - Color Extensions (used as fallback if Asset Catalog colors not set)
// Add these colors to your Assets.xcassets:
//   accent   → #00E5FF  (cyan/teal)
//   bgTop    → #0A0E1A  (very dark navy)
//   bgBottom → #111827  (dark blue-gray)

extension Color {
    static let appAccent = Color(red: 0.0, green: 0.898, blue: 1.0)       // #00E5FF
    static let appBgTop = Color(red: 0.039, green: 0.055, blue: 0.102)    // #0A0E1A
    static let appBgBottom = Color(red: 0.067, green: 0.094, blue: 0.153) // #111827
}

// MARK: - Preview Helper
struct SubnetCalculatorPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
