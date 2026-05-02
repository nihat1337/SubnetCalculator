//
//  SubnetModel.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

// MARK: - IP Classification

enum IPClass: String {
    case a = "Class A"
    case b = "Class B"
    case c = "Class C"
    case d = "Class D (Multicast)"
    case e = "Class E (Reserved)"
    case unknown = "Unknown"

    var color: Color {
        switch self {
        case .a: return .green
        case .b: return .blue
        case .c: return Color(red: 0, green: 0.9, blue: 1)
        case .d: return .purple
        case .e: return .orange
        case .unknown: return .gray
        }
    }
    
    var range: String {
        switch self {
        case .a: return "1.0.0.0 – 126.255.255.255"
        case .b: return "128.0.0.0 – 191.255.255.255"
        case .c: return "192.0.0.0 – 223.255.255.255"
        case .d: return "224.0.0.0 – 239.255.255.255"
        case .e: return "240.0.0.0 – 255.255.255.255"
        case .unknown: return "—"
        }
    }
}

// MARK: - Division Options

enum DivisionParts: Int, CaseIterable {
    case two = 2
    case four = 4
    case eight = 8
    
    var bitsNeeded: Int {
        switch self {
        case .two: return 1
        case .four: return 2
        case .eight: return 3
        }
    }
    
    var label: String { "÷ \(rawValue)" }
}

// MARK: - Execution Mode

enum ExecMode: String, CaseIterable {
    case sequential = "Sequential"
    case parallel = "Parallel"
    
    var icon: String {
        self == .sequential ? "arrow.down.circle" : "bolt.circle"
    }
}

// MARK: - Subnet Result

struct SubnetResult: Identifiable {
    let id = UUID()
    let index: Int
    let network: String
    let broadcast: String
    let firstHost: String
    let lastHost: String
    let mask: String
    let cidr: String
    let total: Int
    let usable: Int
}
