//
//  AppLifecycleMonitor.swift
//  AsyncStreamDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import UIKit

enum AppLifecycleEvent {
    case foreground
    case background
}

class AppLifecycleMonitor {
    
    // Stream that we are going to be observing
    let events: AsyncStream<AppLifecycleEvent>
    
    // Store in memory the continuation to yield through observers
    private var continuation: AsyncStream<AppLifecycleEvent>.Continuation?
    
    init() {
        // Create the stream and capture the continuation
        var capturedContinuation: AsyncStream<AppLifecycleEvent>.Continuation?
        
        events = AsyncStream { continuation in
            capturedContinuation = continuation
        }
        
        self.continuation = capturedContinuation
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.continuation?.yield(.foreground)
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.continuation?.yield(.background)
        }
        
        // Clean when the stream ends
        continuation?.onTermination = { [weak self] _ in
            NotificationCenter.default.removeObserver(self as Any)
        }
    }
}
