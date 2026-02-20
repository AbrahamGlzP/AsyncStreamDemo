//
//  AsyncStreamDemoApp.swift
//  AsyncStreamDemo
//
//  Created by Abraham Gonzalez Puga on 19/02/26.
//

import SwiftUI

@main
struct AsyncStreamDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
