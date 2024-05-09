//
//  ItemService.swift
//  Storybox
//
//  Created by User on 07.05.24.
//

import CoreData

class ItemService {
    static let shared = ItemService()
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistentStore.shared.context) {
        self.context = context
    }

    func createItem(from appState: AppState, recordingURL: URL?) {
        
        print("prepare item")
        
        let newItem = Item(context: context)
        
        // Fetch the provenance details safely
        let provenanceID = appState.getSelectedProvenanceID() ?? 0  // Provide a default ID if nil
        let provenance = appState.provenances.first { $0.id == provenanceID }
        
        // Computed property to get relevant questions based on the selected topic
         var relevantQuestions: [Question] {
            guard let topic = appState.selectedTopic else { return [] }
            guard let questionIDs = topic.questionIDs as? [Int] else { return [] }
            return appState.questions.filter { question in
                questionIDs.contains(Int(question.id))
            }
        }
        
        print("relevantQuestions: \(relevantQuestions)")
        
        if let recordingURL = recordingURL, let savedURL = saveRecordingPermanent(recordingURL) {
            newItem.file = savedURL.absoluteString
        }

        newItem.id = UUID()
        newItem.title = relevantQuestions[safe: appState.currentQuestionIndex]?.title ?? "Unknown Title"
        newItem.itemDescription = "\(appState.nickname) hat auf die Frage: \(newItem.title ?? "Unknown Title") geantwortet. Standort war das \(provenance?.spatial ?? "Unknown Locality"). Der Anlass war \(provenance?.title ?? "Unknown Provenance")"
        newItem.creator = appState.realName
        newItem.email = appState.email
        newItem.locality = appState.locality
        newItem.nickname = appState.nickname
        newItem.dateAccepted = "Terms accepted at \(Date().formatted(date: .abbreviated, time: .omitted))"
        newItem.language = "Deutsch"
        newItem.rights = "CC-BY-SA 4.0"
        newItem.contributor = ""
        newItem.subject = relevantQuestions[safe: appState.currentQuestionIndex]?.id ?? 0
        newItem.provenance = Int32(provenanceID)

        print("try to save this item: \(newItem)")
        
        saveContext()
    }
    
    func saveRecordingPermanent(_ temporaryURL: URL) -> URL? {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Recordings")

        // Attempt to create the directory if it does not exist
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)

        // Extract the file extension from the original file
        let originalFileExtension = temporaryURL.pathExtension
        let newFileName = UUID().uuidString + "." + originalFileExtension // Maintain the original file extension
        let permanentURL = directory.appendingPathComponent(newFileName)

        do {
            try fileManager.moveItem(at: temporaryURL, to: permanentURL)
            return permanentURL
        } catch {
            print("Failed to move recorded file: \(error)")
            return nil
        }
    }


    private func saveContext() {
        do {
            try context.save()
            print("Item saved successfully")
        } catch {
            print("Failed to save item: \(error)")
        }
    }
}

extension ItemService {
    func deleteItem(_ item: Item) {
        if let filePath = item.file, let fileURL = URL(string: filePath) {
            // Attempt to delete the file
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("File successfully deleted at path: \(fileURL.path)")
            } catch {
                print("Failed to delete file at path: \(fileURL.path) with error: \(error)")
            }
        }

        // Delete the item from Core Data
        context.delete(item)
        saveContext()
    }
}
