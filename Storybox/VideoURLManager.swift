//
//  VideoURLManager.swift
//  Storybox
//
//  Created by User on 27.04.24.
//

import Foundation

class VideoURLManager: ObservableObject {
    static let shared = VideoURLManager()
    @Published var outputFileLocation: URL?

    private init() {}  // Private initializer to ensure it cannot be instantiated outside
}
