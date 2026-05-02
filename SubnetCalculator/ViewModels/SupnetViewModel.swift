//
//  SupnetViewModel.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI
import Combine

@MainActor
class SubnetViewModel: ObservableObject {
    

    
    // Input properties
    @Published var ip = ""
    @Published var cidrText = "24"
    @Published var parts: DivisionParts = .four
    @Published var mode: ExecMode = .sequential
    
    // Output properties
    @Published var results: [SubnetResult] = []
    @Published var calculating = false
    @Published var progress: Double = 0
    @Published var error: String? = nil
    @Published var done = false
    
    // Original network summary
    @Published var origNetwork = ""
    @Published var origBroadcast = ""
    @Published var origMask = ""
    @Published var origCIDR = 0
    @Published var ipClass: IPClass = .unknown
    
    
    var cidrVal: Int {
        Int(cidrText) ?? -1
    }
    
    var valid: Bool {
        validIP(ip) && cidrVal >= 0 && cidrVal <= 32
    }
    
    // MARK: - Public Methods
    
    func calculate() {
        guard valid else {
            error = "Enter a valid IP and CIDR (0–32)."
            return
        }
        
        error = nil
        results = []
        done = false
        progress = 0
        calculating = true
        
        guard let raw = toUInt32(ip) else {
            error = "Bad IP."
            calculating = false
            return
        }
        
        let cidr = cidrVal
        let maskU: UInt32 = cidr == 0 ? 0 : (0xFFFFFFFF << (32 - cidr))
        let netBase = raw & maskU
        let bcast = netBase | ~maskU
        
        ipClass = detectClass(raw)
        origNetwork   = SubnetViewModel.toStr(netBase)
        origBroadcast = SubnetViewModel.toStr(bcast)
        origMask      = SubnetViewModel.toStr(maskU)
        origCIDR      = cidr
        
        let newCIDR = cidr + parts.bitsNeeded
        guard newCIDR <= 32 else {
            error = "Cannot subdivide: new prefix /\(newCIDR) exceeds /32."
            calculating = false
            return
        }
        
        let newMask: UInt32 = 0xFFFFFFFF << (32 - newCIDR)
        let size: UInt32    = newCIDR < 32 ? (1 << (32 - newCIDR)) : 1
        let count = parts.rawValue
        
        if mode == .sequential {
            Task {
                await seqCalc(base: netBase, newCIDR: newCIDR, mask: newMask, size: size, count: count)
            }
        } else {
            Task {
                await parCalc(base: netBase, newCIDR: newCIDR, mask: newMask, size: size, count: count)
            }
        }
    }
    
    func reset() {
        ip = ""
        cidrText = "24"
        results = []
        error = nil
        done = false
        progress = 0
        calculating = false
        ipClass = .unknown
    }
    
    func liveClass() -> IPClass? {
        guard validIP(ip), let u = toUInt32(ip) else { return nil }
        return detectClass(u)
    }
    
    // MARK: - Private Methods - Calculation
    
    private func seqCalc(base: UInt32, newCIDR: Int, mask: UInt32, size: UInt32, count: Int) async {
        for i in 0..<count {
            let r = SubnetViewModel.makeResult(
                i: i,
                base: base,
                size: size,
                mask: mask,
                cidr: newCIDR
            )
            try? await Task.sleep(nanoseconds: 400_000_000)
            results.append(r)
            progress = Double(i + 1) / Double(count)
        }
        calculating = false
        done = true
    }
    
    private func parCalc(base: UInt32, newCIDR: Int, mask: UInt32, size: UInt32, count: Int) async {
        var out = [SubnetResult?](repeating: nil, count: count)
        
        await withTaskGroup(of: (Int, SubnetResult).self) { group in
            for i in 0..<count {
                group.addTask {
                    (i, SubnetViewModel.makeResult(
                        i: i,
                        base: base,
                        size: size,
                        mask: mask,
                        cidr: newCIDR
                    ))
                }
            }
            
            var done = 0
            for await (i, r) in group {
                out[i] = r
                done += 1
                progress = Double(done) / Double(count)
            }
        }
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        results = out.compactMap { $0 }
        calculating = false
        done = true
    }
    
    private nonisolated static func makeResult(
        i: Int,
        base: UInt32,
        size: UInt32,
        mask: UInt32,
        cidr: Int
    ) -> SubnetResult {
        let net   = base + UInt32(i) * size
        let bcast = net + size - 1
        let fh    = size > 2 ? net + 1 : net
        let lh    = size > 2 ? bcast - 1 : bcast
        
        return SubnetResult(
            index: i + 1,
            network: Self.toStr(net),
            broadcast: Self.toStr(bcast),
            firstHost: Self.toStr(fh),
            lastHost: Self.toStr(lh),
            mask: Self.toStr(mask),
            cidr: "/\(cidr)",
            total: Int(size),
            usable: size > 2 ? Int(size) - 2 : 0
        )
    }
    
    // MARK: - Helper Methods
    
    func validIP(_ s: String) -> Bool {
        let p = s.split(separator: ".", omittingEmptySubsequences: false)
        guard p.count == 4 else { return false }
        return p.allSatisfy {
            if let n = Int($0) {
                return n >= 0 && n <= 255
            } else {
                return false
            }
        }
    }
    
    func toUInt32(_ s: String) -> UInt32? {
        let p = s.split(separator: ".").compactMap { UInt32($0) }
        guard p.count == 4 else { return nil }
        return (p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3]
    }
    
    nonisolated static func toStr(_ v: UInt32) -> String {
        "\((v>>24)&0xFF).\((v>>16)&0xFF).\((v>>8)&0xFF).\(v&0xFF)"
    }
    
    func detectClass(_ v: UInt32) -> IPClass {
        switch (v >> 24) & 0xFF {
        case 1...126: return .a
        case 128...191: return .b
        case 192...223: return .c
        case 224...239: return .d
        case 240...255: return .e
        default: return .unknown
        }
    }
}
