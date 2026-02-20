//
//  AppLifecycleDetalViewModel.swift
//  AsyncStreamDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import SwiftUI
import Foundation

class AppLifecycleDetailViewModel: ObservableObject {
    
    @Published var events: [String] = []
    @Published var currentState: AppLifecycleEvent = .foreground
    
    private var appLifeCycleMonitor: AppLifecycleMonitor
    
    init(appLifeCycleMonitor: AppLifecycleMonitor) {
        self.appLifeCycleMonitor = appLifeCycleMonitor
    }
    
    @MainActor
    func startObserving() async {
        // Iterate the stream with the for await
        for await event in appLifeCycleMonitor.events {
            // This switch is only for demonstrational purposes
            switch event {
            case .foreground:
                currentState = .foreground
                events.insert("🟢 Foreground - \(timestamp())", at: 0)
            case .background:
                currentState = .background
                events.insert("🔴 Background - \(timestamp())", at: 0)
            }
        }
    }
    
    func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: Date.now)
    }
}
