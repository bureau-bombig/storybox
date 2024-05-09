//
//  VideoURLManager.swift
//  Storybox
//
//  Created by User on 27.04.24.
//

// FileURLManager.swift
import Foundation

class FileURLManager: ObservableObject {
    static let shared = FileURLManager()
    @Published var outputFileLocation: URL?

    private init() {}  // Private initializer to ensure it cannot be instantiated outside
    
    func deleteFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("File successfully deleted at path: \(url.path)")
        } catch {
            print("Failed to delete file: \(error)")
        }
    }
}

