//
//  TUSClientManager.swift
//  Storybox
//
//  Created by User on 09.05.24.
//

import Foundation
import TUSKit
import SwiftUI

class TUSClientManager: NSObject, ObservableObject, TUSClientDelegate {
    static let shared = TUSClientManager()
    var tusClient: TUSClient?
    @Published var itemIdToUploadProgress: [UUID: Double] = [:]
    @Published var itemIdToUploadStatus: [UUID: String] = [:]
    var uploadIdToItemId: [UUID: UUID] = [:]
    var completionHandlers: [UUID: (Bool) -> Void] = [:]


    override init() {
        super.init()
        configureTUSClient()
    }
    
    

    private func configureTUSClient() {
        do {
            let serverURL = URL(string: "https://storybox.freiheitsarchiv.de/")!
            let storageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("TUS")
            
            tusClient = try TUSClient(
                server: serverURL,
                sessionIdentifier: "StoryboxSession",
                sessionConfiguration: URLSessionConfiguration.default, // Adjust this accordingly
                storageDirectory: storageURL,
                supportedExtensions: [.creation]
            )
            tusClient?.delegate = self
        } catch {
            print("Failed to configure TUSClient: \(error)")
        }
    }


    // Implement TUSClientDelegate methods
    func didStartUpload(id: UUID, context: [String: String]?, client: TUSClient) {
        DispatchQueue.main.async {
            if let itemId = self.uploadIdToItemId[id] {
                self.itemIdToUploadStatus[itemId] = "Uploading..."
                self.itemIdToUploadProgress[itemId] = 0.0
            }
        }
    }

    func didFinishUpload(id: UUID, url: URL, context: [String: String]?, client: TUSClient) {
        DispatchQueue.main.async {
            if let itemId = self.uploadIdToItemId[id] {
                self.itemIdToUploadStatus[itemId] = "Completed"
                self.itemIdToUploadProgress[itemId] = 100.0
                self.uploadIdToItemId.removeValue(forKey: id)
                // Assuming you have some mechanism to track completion handlers
                self.completionHandlers[itemId]?(true)
                self.completionHandlers.removeValue(forKey: itemId)
            }
        }
    }

    func uploadFailed(id: UUID, error: Error, context: [String: String]?, client: TUSClient) {
        DispatchQueue.main.async {
            if let itemId = self.uploadIdToItemId[id] {
                self.itemIdToUploadStatus[itemId] = "Failed: \(error.localizedDescription)"
                self.itemIdToUploadProgress[itemId] = nil
                // Assuming you have some mechanism to track completion handlers
                self.completionHandlers[itemId]?(false)
                self.completionHandlers.removeValue(forKey: itemId)
            }
        }
    }
    
    func fileError(error: TUSClientError, client: TUSClient) {
        print("File error: \(error)")
        // You can decide how to handle file errors. For example:
        DispatchQueue.main.async {
            for (uploadId, itemId) in self.uploadIdToItemId {
                self.itemIdToUploadStatus[itemId] = "File Error: \(error.localizedDescription)"
            }
        }
    }

    @available(iOS 11.0, macOS 10.13, *)
    func totalProgress(bytesUploaded: Int, totalBytes: Int, client: TUSClient) {
        // If you want to print to console or do something else globally:
        print("Total progress: \(bytesUploaded)/\(totalBytes)")
    }

    @available(iOS 11.0, macOS 10.13, *)
    func progressFor(id: UUID, context: [String: String]?, bytesUploaded: Int, totalBytes: Int, client: TUSClient) {
        DispatchQueue.main.async {
            if let itemId = self.uploadIdToItemId[id] {
                let progress = Double(bytesUploaded) / Double(totalBytes)
                self.itemIdToUploadProgress[itemId] = progress
                self.itemIdToUploadStatus[itemId] = "Uploading... \(Int(progress * 100))%"
            }
        }
    }

    
    
    
    func upload(fileAtPath filePath: URL, withMetadata metadata: [String: String], forItemWithId itemId: UUID, completion: @escaping (Bool) -> Void) {

        completionHandlers[itemId] = completion

        guard let tusClient = tusClient else {
            print("TUSClient is not configured")
            completion(false)
            return
        }

        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                let uploadId = try tusClient.uploadFileAt(filePath: filePath, customHeaders: [:], context: metadata)
                DispatchQueue.main.async {
                    self.uploadIdToItemId[uploadId] = itemId
                    self.itemIdToUploadStatus[itemId] = "Preparing..."
                }
                print("Upload started for file at \(filePath)")
                // Assume success for now; actual success will be determined by delegate callbacks
            } catch {
                print("Failed to start upload: \(error)")
                completion(false)
            }
        } else {
            print("File does not exist at path: \(filePath.path)")
            completion(false)
        }
    }
    
}
