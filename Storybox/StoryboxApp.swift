//
//  StoryboxApp.swift
//  Storybox
//
//  Created by User on 24.04.24.
//

import SwiftUI

@main
struct StoryboxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
        }
    }
}
