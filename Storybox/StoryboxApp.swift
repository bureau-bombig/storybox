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
    
    init() {
        QuestionIDsValueTransformer.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
                .environmentObject(CameraSessionManager())
                .environment(\.managedObjectContext, persistentStore.context)
        }
    }
}
