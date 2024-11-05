//
//  StoryboxApp.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI

@main
struct StoryboxApp: App {
    let persistentStore = PersistentStore.shared
    let appState = AppState()
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @Environment(\.scenePhase) var scenePhase


    init() {
        AppManager.shared.setup(with: appState)
        QuestionIDsValueTransformer.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.managedObjectContext, persistentStore.context)
                .environmentObject(networkMonitor)
                .onAppear {
                             BackgroundTaskScheduler.shared.scheduleBackgroundTask()
                         }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                BackgroundTaskScheduler.shared.scheduleBackgroundTask()
            }
        }
    }
}
