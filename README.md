<div align="center">

<br/>

```
 ███████╗██╗   ██╗██████╗ ███╗   ██╗███████╗████████╗ ██████╗ █████╗ ██╗      ██████╗
 ██╔════╝██║   ██║██╔══██╗████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗██║     ██╔════╝
 ███████╗██║   ██║██████╔╝██╔██╗ ██║█████╗     ██║   ██║     ███████║██║     ██║     
 ╚════██║██║   ██║██╔══██╗██║╚██╗██║██╔══╝     ██║   ██║     ██╔══██║██║     ██║     
 ███████║╚██████╔╝██████╔╝██║ ╚████║███████╗   ██║   ╚██████╗██║  ██║███████╗╚██████╗
 ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝
```

# SubnetCalc

**A modern iOS subnet division calculator built with SwiftUI & MVVM**

<br/>

[![Swift](https://img.shields.io/badge/Swift-5.9-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-0071E3?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![iOS](https://img.shields.io/badge/iOS-17%2B-black?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/ios)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-147EFB?style=for-the-badge&logo=xcode&logoColor=white)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/License-MIT-00E5FF?style=for-the-badge)](LICENSE)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM-8A2BE2?style=for-the-badge)]()

<br/>

> 🎓 **Computer Networks Course Project** — Subnet division made visual, animated, and educational.

<br/>

---

</div>

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [How Subnetting Works](#-how-subnetting-works)
- [Sequential vs Parallel](#-sequential-vs-parallel)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Test Cases](#-test-cases)
- [Technologies](#-technologies)

---

## 🌐 Overview

**SubnetCalc** is an iOS application that lets you divide any IPv4 network into **2, 4, or 8 equal subnets** with a single tap. It visualizes every subnet's details — network ID, broadcast address, first/last host, subnet mask — and demonstrates the difference between **sequential** and **parallel** computation using Swift Concurrency.

Built as a Computer Networks project to reinforce understanding of:

- IPv4 addressing and CIDR notation
- Subnetting and address space division
- Bitwise arithmetic on IP addresses
- Concurrent programming with Swift's async/await

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🧮 Networking
- ✅ IPv4 address validation (live, as you type)
- ✅ CIDR prefix input `/0` – `/32`
- ✅ IP Class detection — **A, B, C, D, E**
- ✅ Divide into **÷2 / ÷4 / ÷8** subnets
- ✅ Per-subnet output:
  - Network ID
  - Broadcast Address
  - First & Last Host
  - Subnet Mask
  - Usable Host Count

</td>
<td width="50%">

### 📱 UI / UX
- ✅ Dark glassmorphism design
- ✅ Live CIDR bar indicator
- ✅ Animated progress bar
- ✅ Staggered card reveal animations
- ✅ Expandable subnet cards
- ✅ Visual address space bar
- ✅ Reset & recalculate flow
- ✅ IP Class color badges

</td>
</tr>
</table>

---

## 📸 Screenshots

```
┌─────────────────────┐   ┌─────────────────────┐   ┌─────────────────────┐
│  ◉ SubnetCalc       │   │  ◉ SubnetCalc        │   │  ◉ SubnetCalc       │
│─────────────────────│   │─────────────────────│   │─────────────────────│
│  NETWORK ADDRESS    │   │  ÷4  Sequential      │   │  Original Network   │
│ ┌─────────────────┐ │   │  ████████░░ 2/4      │   │  192.168.1.0 /24    │
│ │ 192.168.1.0     │ │   │─────────────────────│   │─────────────────────│
│ └─────────────────┘ │   │  ① Subnet 1          │   │  ① Subnet 1   ▼     │
│  / [24] ████████░░  │   │  192.168.1.0/26      │   │  Network: 192.168.1.0│
│  Class C · 192–223  │   │  62 usable hosts     │   │  Broadcast:    .63  │
│─────────────────────│   │─────────────────────│   │  First Host:    .1  │
│  DIVIDE INTO        │   │  ② Subnet 2          │   │  Last Host:    .62  │
│  [÷2] [÷4] [÷8]    │   │  192.168.1.64/26     │   │  Mask: 255.255.255.192│
│─────────────────────│   │  62 usable hosts     │   │  CIDR:         /26  │
│  MODE               │   │─────────────────────│   │─────────────────────│
│  [Sequential][Par.] │   │  ③ Subnet 3...       │   │  ② Subnet 2   ▶     │
│─────────────────────│   │                     │   │  192.168.1.64/26    │
│  [ ▶ Calculate  ]   │   │                     │   │  62 usable hosts    │
└─────────────────────┘   └─────────────────────┘   └─────────────────────┘
      Input Screen              Progress                   Results
```

---

## 🏗 Architecture

This project follows the **MVVM** (Model-View-ViewModel) pattern:

```
┌─────────────────────────────────────────────────────────┐
│                        MVVM                             │
│                                                         │
│  ┌──────────┐    @Published    ┌──────────────────────┐ │
│  │          │ ◄─────────────── │                      │ │
│  │  VIEWS   │                  │    VIEW MODEL (VM)   │ │
│  │          │ ──────────────►  │    @MainActor        │ │
│  │ SwiftUI  │   User Actions   │    ObservableObject  │ │
│  └──────────┘                  └──────────┬───────────┘ │
│                                           │             │
│                                    reads/writes         │
│                                           │             │
│                                ┌──────────▼───────────┐ │
│                                │       MODELS         │ │
│                                │  SubnetResult        │ │
│                                │  IPClass             │ │
│                                │  DivisionParts       │ │
│                                │  ExecMode            │ │
│                                └──────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | File(s) | Responsibility |
|-------|---------|----------------|
| **Model** | `SubnetResult`, `IPClass`, `DivisionParts`, `ExecMode` | Pure data structures, no logic |
| **ViewModel** | `SubnetViewModel.swift` | All business logic, subnet math, concurrency |
| **View** | `ContentView`, `InputCard`, `OptionsCard`, `SubnetCard`... | Display only, zero business logic |

---

## 🧮 How Subnetting Works

### The Math

```
New CIDR  =  Original CIDR  +  Bits Borrowed
              ÷2 → borrow 1 bit
              ÷4 → borrow 2 bits
              ÷8 → borrow 3 bits

Subnet Size  =  2 ^ (32 - new_CIDR)
Usable Hosts =  Subnet Size  -  2   (network + broadcast reserved)
```

### Worked Example — `192.168.1.0 / 24` divided by **4**

```
Original: 192.168.1.0/24
Borrow 2 bits → new CIDR = /26
Subnet size = 2^(32-26) = 64 addresses each

┌────────┬─────────────────┬──────────────┬─────────────────┬───────────┐
│ Subnet │ Network ID      │ First Host   │ Last Host       │ Broadcast │
├────────┼─────────────────┼──────────────┼─────────────────┼───────────┤
│   1    │ 192.168.1.0     │ 192.168.1.1  │ 192.168.1.62    │ .63       │
│   2    │ 192.168.1.64    │ 192.168.1.65 │ 192.168.1.126   │ .127      │
│   3    │ 192.168.1.128   │ 192.168.1.129│ 192.168.1.190   │ .191      │
│   4    │ 192.168.1.192   │ 192.168.1.193│ 192.168.1.254   │ .255      │
└────────┴─────────────────┴──────────────┴─────────────────┴───────────┘
                        62 usable hosts per subnet
```

### IP Address Classes

| Class | First Octet | Range | Default Mask | Usage |
|-------|-------------|-------|--------------|-------|
| **A** | 1 – 126 | `1.0.0.0` – `126.255.255.255` | /8 | Large enterprises |
| **B** | 128 – 191 | `128.0.0.0` – `191.255.255.255` | /16 | Medium networks |
| **C** | 192 – 223 | `192.0.0.0` – `223.255.255.255` | /24 | Small networks |
| **D** | 224 – 239 | `224.0.0.0` – `239.255.255.255` | — | Multicast |
| **E** | 240 – 255 | `240.0.0.0` – `255.255.255.255` | — | Reserved |

---

## ⚡ Sequential vs Parallel

One of the key educational features of this app is demonstrating two computation strategies:

### 🔢 Sequential Mode
```
Task starts
    │
    ├─► Compute Subnet 1 ──► wait 0.4s ──► append to results
    │
    ├─► Compute Subnet 2 ──► wait 0.4s ──► append to results
    │
    ├─► Compute Subnet 3 ──► wait 0.4s ──► append to results
    │
    └─► Compute Subnet 4 ──► wait 0.4s ──► done ✓

Total time: 4 × 0.4s = ~1.6s (visible one-by-one animation)
```
Implementation: `Task { await seqCalc() }` with `Task.sleep`

### ⚡ Parallel Mode
```
Task starts
    │
    ├──────────────────────────────────────────────┐
    │                                              │
    ├─► Subnet 1 ┐                                 │
    ├─► Subnet 2 ├── All computed simultaneously   │
    ├─► Subnet 3 │   via Swift TaskGroup           │
    └─► Subnet 4 ┘                                 │
                 └──────────────────────────────── ► done ✓

Total time: ~0.2s (all at once)
```
Implementation: `withTaskGroup(of:)` — Swift Structured Concurrency

| | Sequential | Parallel |
|---|:---:|:---:|
| Visual effect | Cards appear one-by-one | All cards appear together |
| Swift API | `Task.sleep` | `withTaskGroup` |
| Real-world use case | Ordered pipelines | Independent batch jobs |

---

## 📁 Project Structure

```
SubnetCalculator/
│
├── 📄 SubnetCalculatorApp.swift      ← @main entry point
│
├── 📁 Models/
│   ├── IPClass.swift                 ← enum: .a .b .c .d .e .unknown
│   ├── SubnetResult.swift            ← struct with all per-subnet data
│   ├── DivisionParts.swift           ← enum: .two .four .eight
│   └── ExecMode.swift                ← enum: .sequential .parallel
│
├── 📁 ViewModels/
│   └── SubnetViewModel.swift         ← @MainActor ObservableObject
│       ├── calculate()               ← main entry, validates & dispatches
│       ├── seqCalc()                 ← sequential async loop
│       ├── parCalc()                 ← parallel withTaskGroup
│       ├── makeResult()              ← nonisolated static, pure math
│       ├── validIP()                 ← IP format validation
│       ├── toUInt32() / toStr()      ← IP ↔ UInt32 conversion
│       └── detectClass()             ← IP class from first octet
│
└── 📁 Views/
    ├── ContentView.swift             ← Root NavigationStack + ScrollView
    ├── InputCardView.swift           ← IP field, CIDR bar, class badge
    ├── OptionsCardView.swift         ← Division picker, mode selector
    ├── CalculateButton.swift         ← Animated calculate button
    ├── ProgressCardView.swift        ← Progress bar during calculation
    ├── OriginalNetworkCard.swift     ← Summary of the original /N network
    └── SubnetCard.swift              ← Expandable card per subnet result
```

---

## 🚀 Getting Started

### Requirements

| Tool | Minimum Version |
|------|----------------|
| macOS | Ventura 13.5+ |
| Xcode | 15.0+ |
| iOS Simulator | iOS 17+ |
| Swift | 5.9+ |

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/SubnetCalculator.git
cd SubnetCalculator

# 2. Open in Xcode
open SubnetCalculator.xcodeproj
```

### Run

1. Select a simulator — e.g. **iPhone 15 Pro**
2. Press `⌘R` or click ▶ in Xcode
3. App launches in ~30 seconds on first build

> **Single-file option:** If using `SubnetCalculator_SingleFile.swift`, simply paste its contents into `ContentView.swift` of a fresh SwiftUI project — no other setup needed.

---

## 🧪 Test Cases

| IP Address | CIDR | Divide | Expected CIDR | Hosts/Subnet |
|------------|------|--------|---------------|:------------:|
| `192.168.1.0` | `/24` | ÷ 4 | `/26` | 62 |
| `192.168.1.0` | `/24` | ÷ 2 | `/25` | 126 |
| `172.16.0.0` | `/16` | ÷ 4 | `/18` | 16,382 |
| `10.0.0.0` | `/8` | ÷ 8 | `/11` | 524,286 |
| `10.0.0.0` | `/8` | ÷ 2 | `/9` | 8,388,606 |
| `192.168.10.0` | `/24` | ÷ 8 | `/27` | 30 |

**Try both Sequential and Parallel modes** on the same input to observe the visual difference!

---

## 🛠 Technologies

<table>
<tr>
<td align="center" width="120">
<br/><b>SwiftUI</b><br/>Declarative UI framework
</td>
<td align="center" width="120">
<br/><b>Swift Concurrency</b><br/>async/await + TaskGroup
</td>
<td align="center" width="120">
<br/><b>Combine</b><br/>@Published + ObservableObject
</td>
<td align="center" width="120">
<br/><b>MVVM</b><br/>Architecture pattern
</td>
</tr>
</table>

### Key Swift Concepts Used

```swift
// Swift Concurrency — Parallel execution
await withTaskGroup(of: (Int, SubnetResult).self) { group in
    for i in 0..<count { group.addTask { ... } }
    for await (i, result) in group { ... }
}

// @MainActor — Thread-safe UI updates
@MainActor class SubnetViewModel: ObservableObject { ... }

// nonisolated static — CPU work off main actor
private nonisolated static func makeResult(...) -> SubnetResult { ... }

// Bitwise IP arithmetic
let mask: UInt32 = 0xFFFFFFFF << (32 - cidr)
let network = ipUInt32 & mask
let broadcast = network | ~mask
```

---

## 👤 Author

**Nihat Samadov**
- 📚 Computer Networks — Course Project
- 📅 April 2026

---

<div align="center">

<br/>

**Built with ❤️ and Swift**

*If this project helped you understand subnetting — give it a ⭐*

<br/>

</div>
