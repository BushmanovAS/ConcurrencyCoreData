//
//  ConcurrencyCoreDataApp.swift
//  ConcurrencyCoreData
//
//  Created by anbushmanov on 09.09.2025.
//

import SwiftUI

@main
struct ConcurrencyCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
