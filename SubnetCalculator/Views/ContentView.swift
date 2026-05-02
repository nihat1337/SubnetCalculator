//
//  ContentView.swift
//  SubnetCalculator
//
//  Created by Nihat Samadov on 26.04.26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SubnetViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        AppHeader()
                        
                        InputCard(viewModel: viewModel)
                        
                        OptionsCard(viewModel: viewModel)
                        
                        CalcButton(viewModel: viewModel)
                        
                        // Error banner
                        if let errorMessage = viewModel.error {
                            ErrorBanner(message: errorMessage)
                        }
                        
                        // Progress indicator
                        if viewModel.calculating {
                            ProgressCard(viewModel: viewModel)
                        }
                        
                        // Results
                        if viewModel.done {
                            OriginalCard(viewModel: viewModel)
                            
                            ForEach(Array(viewModel.results.enumerated()), id: \.element.id) { index, subnet in
                                SubnetCard(
                                    subnet: subnet,
                                    delay: Double(index) * 0.08
                                )
                            }
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
            }
            .navigationTitle("SubnetCalc")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                if viewModel.done || viewModel.calculating {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Reset") {
                            withAnimation {
                                viewModel.reset()
                            }
                        }
                        .foregroundStyle(Color(red: 0, green: 0.9, blue: 1))
                    }
                }
            }
        }
    }
    
    // MARK: - Background Gradient
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.06, blue: 0.12),
                Color(red: 0.07, green: 0.10, blue: 0.18)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
