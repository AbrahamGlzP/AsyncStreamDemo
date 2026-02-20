//
//  AppLifecycleDetailView.swift
//  AsyncStreamDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import SwiftUI

struct AppLifecycleDetailView: View {
    
    @StateObject private var viewModel = AppLifecycleDetailViewModel(appLifeCycleMonitor: AppLifecycleMonitor())
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                
                HStack {
                    Circle()
                        .fill(viewModel.currentState == .foreground ? .green : .red)
                        .frame(width: 12, height: 12)
                    Text(viewModel.currentState == .foreground ? "In foreground" : "In background")
                        .font(.subheadline)
                        .foregroundStyle(ForegroundStyle().secondary)
                }
                .padding()
                
                Divider()
                
                // Events history
                if viewModel.events.isEmpty {
                    Spacer()
                    Text("Send the app to background to watch events")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(ForegroundStyle().secondary)
                    Spacer()
                } else {
                    List(viewModel.events, id: \.self) { event in
                        Text(event)
                            .font(
                                .system(.body, design: .monospaced)
                            )
                    }
                }
            }
            .navigationTitle("AsyncStream Demo!!!")
            .task {
                await viewModel.startObserving()
            }
        }
    }
}
