//
//  AppManager.swift
//  Storybox
//
//  Created by User on 08.05.24.
//

import SwiftUI

class AppManager {
    static let shared = AppManager()  // Singleton instance
    var appState: AppState?
    private var idleTimer: Timer?


    private init() {}

    func setup(with appState: AppState) {
        self.appState = appState
    }

    func resetIdleTimer() {
        idleTimer?.invalidate()
        idleTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: false) { [weak self] _ in
            self?.restartApplication()
        }
    }
    
    func restartApplication() {
        guard let appState = appState else {
            print("AppState is not set!")
            return
        }
        
        // Perform any cleanup or reset tasks
        print("Restarting application...")
        appState.realName = ""
        appState.email = ""
        appState.nickname = ""
        appState.locality = ""
        appState.currentQuestionIndex = 0
        appState.selectedTopic = nil
        appState.recordings.removeAll()
        appState.isAudioOnly = false
        
        appState.currentView = .welcome
        // Add more reset logic here as needed
    }
}
