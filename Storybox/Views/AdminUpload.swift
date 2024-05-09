//
//  AdminUpload.swift
//  Storybox
//
//  Created by User on 01.05.24.
//

import SwiftUI

struct AdminUpload: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var tusManager = TUSClientManager.shared

    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.dateAccepted, ascending: false)]
    ) var items: FetchedResults<Item>
    
    
    
    var body: some View {
        VStack {
            header
            listSection
            footer
        }
        .padding(80)
        .background(Color.AppPrimary)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            print(items.count)
        }
    }

    var header: some View {
        HStack {
            Text("Beiträge hochladen (\(items.count))")
                .font(.golosUIBold(size: 45))
                .foregroundColor(.white)
            Spacer()
        }
    }

    var listSection: some View {
        ScrollView {
            ForEach(items, id: \.self) { item in
                itemRow(item)
                    .padding(.vertical, 4)
            }
        }
    }

    var footer: some View {
        HStack {
            Button("Zurück") {
                appState.currentView = .adminSettings
            }
            .styledButton()

            Spacer()

            Button("Alle Uploaden") {
                uploadAllItems()
            }
            .styledButton()
        }
        .padding(.top, 20)
    }

    private func itemRow(_ item: Item) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Eintrag von: \(item.nickname ?? "Unbekannt")")
                    .font(.golosUIBold(size: 28))
                    .foregroundColor(.white)
                
                Text("Frage: \(item.title ?? "Unbekannte Frage")")
                    .font(.golosUIRegular(size: 20))
                    .foregroundColor(.white)
                
                Text("Standort: \(item.locality ?? "Unbekannt") - Anlass: \(item.provenance)")
                    .font(.golosUIRegular(size: 16))
                    .foregroundColor(.white)
                
                Text("Erstellungdatum: \(item.dateAccepted ?? "Unbekanntes Datum")")
                    .font(.golosUIRegular(size: 16))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    deleteItem(item)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.red))
                }
                
                Button(action: {
                    uploadItem(item) { success in
                        if success {
                            print("Upload successful for item: \(item.id?.uuidString ?? "unknown ID")")
                            // Execute deletion after a successful upload
                            DispatchQueue.main.async {
                                ItemService.shared.deleteItem(item)
                                print("Item deleted successfully: \(item.id?.uuidString ?? "unknown ID")")
                            }
                        } else {
                            print("Upload failed for item: \(item.id?.uuidString ?? "unknown ID")")
                        }
                    }
                }) {
                    Image(systemName: "arrow.up.circle")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.green))
                }
                VStack {
                    if let id = item.id, let status = tusManager.itemIdToUploadStatus[id] {
                        Text(status)
                            .font(.golosUIRegular(size: 16))
                            .foregroundColor(status == "Completed" ? Color.green : (status.contains("Failed") ? Color.red : Color.yellow))
                    } else {
                        Text("Ready to upload")
                            .font(.golosUIRegular(size: 16))
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
        .padding(32)
        .background(Color.AppPrimaryDark)
        .cornerRadius(10)
    }

    // Upload all items sequentially
    private func uploadAllItems() {
        var index = 0
        let total = items.count
        func uploadNext() {
            if index < total {
                let item = items[index]
                uploadItem(item) { success in
                    if success {
                        // Mark as completed or something similar
                    }
                    index += 1
                    uploadNext()
                }
            } else {
                // All uploads are done, now handle deletions
                deleteUploadedItems()
            }
        }
        uploadNext()
    }

    // Delete items that were successfully uploaded
    private func deleteUploadedItems() {
        for item in items {
            if tusManager.itemIdToUploadStatus[item.id!] == "Completed" {
                ItemService.shared.deleteItem(item)
            }
        }
    }

}

private func uploadItem(_ item: Item, completion: @escaping (Bool) -> Void) {
    guard let fileURLString = item.file, let url = URL(string: fileURLString) else {
        print("Invalid file URL stored for item.")
        completion(false)
        return
    }
    guard let itemId = item.id else {
        print("Invalid item ID.")
        completion(false)
        return
    }
    let fileName = url.lastPathComponent
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Unable to find the documents directory")
        completion(false)
        return
    }
    let recordingFilePath = documentsDirectory.appendingPathComponent("Recordings").appendingPathComponent(fileName).path
    if FileManager.default.fileExists(atPath: recordingFilePath) {
        let fileURL = URL(fileURLWithPath: recordingFilePath)
        var metadata: [String: String] = [:]
        metadata["creator"] = item.creator ?? "Unknown"
        metadata["nickname"] = item.nickname ?? "Unknown"
        metadata["email"] = item.email ?? "Unknown"
        metadata["locality"] = item.locality ?? "Unknown"
        metadata["contributor"] = item.contributor ?? "Unknown"
        metadata["dateAccepted"] = item.dateAccepted ?? "Date not available"
        metadata["itemDescription"] = item.itemDescription ?? "No description available"
        metadata["title"] = item.title ?? "No title"
        metadata["subject"] = String(item.subject)
        metadata["provenance"] = String(item.provenance)
        metadata["rights"] = item.rights ?? "No rights specified"
        metadata["language"] = item.language ?? "No language specified"


        print("Attempting to upload: \(fileURL.path)")
        TUSClientManager.shared.upload(fileAtPath: fileURL, withMetadata: metadata, forItemWithId: itemId) { success in
            print("Upload result for \(fileURL.path): \(success)")
            completion(success)
        }
    } else {
        print("File does not exist at path: \(recordingFilePath)")
        completion(false)
    }
}


/*
private func uploadItem(_ item: Item, completion: @escaping (Bool) -> Void) {
    // Ensure the file URL string is not nil and is a valid URL
    guard let fileURLString = item.file, let url = URL(string: fileURLString) else {
        print("Invalid file URL stored for item.")
        completion(false)
        return
    }
    
    // Ensure item.id is not nil
    guard let itemId = item.id else {
        print("Invalid item ID.")
        completion(false)
        return
    }

    // Extract the file name from the URL
    let fileName = url.lastPathComponent

    // Retrieve the Documents directory path
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Unable to find the documents directory")
        completion(false)
        return
    }

    // Construct the full file path
    let recordingFilePath = documentsDirectory.appendingPathComponent("Recordings").appendingPathComponent(fileName).path
    
    // Check if the file exists at this path
    if FileManager.default.fileExists(atPath: recordingFilePath) {
        let fileURL = URL(fileURLWithPath: recordingFilePath)
        

        
        // Define metadata for the upload        
        var metadata: [String: String] = [:]
        metadata["creator"] = item.creator ?? "Unknown"
        metadata["nickname"] = item.nickname ?? "Unknown"
        metadata["email"] = item.email ?? "Unknown"
        metadata["locality"] = item.locality ?? "Unknown"
        metadata["contributor"] = item.contributor ?? "Unknown"
        metadata["dateAccepted"] = item.dateAccepted ?? "Date not available"
        metadata["itemDescription"] = item.itemDescription ?? "No description available"
        metadata["title"] = item.title ?? "No title"
        metadata["subject"] = String(item.subject)
        metadata["provenance"] = String(item.provenance)
        metadata["rights"] = item.rights ?? "No rights specified"
        metadata["language"] = item.language ?? "No language specified"
        
        TUSClientManager.shared.upload(fileAtPath: fileURL, withMetadata: metadata, forItemWithId: itemId) { success in
            completion(success)
        }
        
        print("Upload started for file at \(fileURL.path)")
    } else {
        print("File does not exist at path: \(recordingFilePath)")
        completion(false)

    }
}
 */



private func deleteItem(_ item: Item) {
    ItemService.shared.deleteItem(item) // Using ItemService to handle deletion
}


#Preview {
    AdminUpload()
}
