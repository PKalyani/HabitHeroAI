//
//  HabitHeroAIApp.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/22/25.
//

import SwiftUI

@main
struct HabitHeroAIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }

    init() {
        NotificationService.shared.requestPermissions()
    }
}
