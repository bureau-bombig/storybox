//
//  BackgroundTaskScheduler.swift
//  Storybox
//
//  Created by User on 13.06.24.
//

import BackgroundTasks
import Network
import SwiftUI

class BackgroundTaskScheduler {
    static let shared = BackgroundTaskScheduler()
    private let networkMonitor = NetworkMonitor()

    private init() {
        registerBackgroundTasks()
    }
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourApp.uploadTask", using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }
    
    func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.yourApp.uploadTask")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background task scheduled")
        } catch {
            print("Failed to schedule background task: \(error.localizedDescription)")
        }
    }
    
    private func handleBackgroundTask(task: BGProcessingTask) {
        scheduleBackgroundTask()
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        if networkMonitor.isConnected {
            uploadAllItems { success in
                task.setTaskCompleted(success: success)
            }
        } else {
            task.setTaskCompleted(success: false)
        }
    }
    
    private func uploadAllItems(completion: @escaping (Bool) -> Void) {
        // Implement your upload logic here
        DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
            print("Upload completed")
            completion(true)
        }
    }
}

