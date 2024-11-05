//
//  AppState.swift
//  Storybox
//
//  Created by User on 25.04.24.
//

import SwiftUI
import CoreData

class AppState: ObservableObject {
    @Published var currentView: AppView = .welcome
    @Published var provenances: [Provenance] = []
    @Published var topics: [Topic] = []
    @Published var questions: [Question] = []
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var realName: String = ""
    @Published var locality: String = ""
    @Published var selectedTopic: Topic?
    @Published var currentQuestionIndex: Int = 0
    @Published var recordings: [URL] = []
    @Published var isAudioOnly: Bool = false
        
    private let context = PersistentStore.shared.context

    init() {
        fetchLocalData()
    }
    
    func fetchLocalData() {
        fetchLocalProvenances()
        fetchLocalTopics()
        fetchLocalQuestions()
    }

    // Provenance related methods
    func fetchProvenancesFromAPI(completion: @escaping () -> Void) {
        ProvenanceService.fetchProvenances { [weak self] items in
            guard let self = self, let items = items else { return }
            DispatchQueue.main.async {
                self.updateProvenanceCoreData(with: items)
                completion() // Trigger UI update after data fetch
            }
        }
    }

    func updateProvenanceCoreData(with items: [ProvenanceItem]) {
        context.perform {
            // Delete all existing provenance entries
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: Provenance.fetchRequest())
            do {
                try self.context.execute(deleteRequest)
                print("All existing provenances deleted.")
            } catch {
                print("Error deleting existing provenances: \(error)")
            }

            // Add new provenances from fetched data
            for item in items {
                let newProvenance = Provenance(context: self.context)
                newProvenance.id = Int32(item.id)
                newProvenance.title = item.titleDetails.first?.value ?? "No title provided"
                newProvenance.spatial = item.spatialDetails.first?.value ?? "No location provided"
            }

            // Save changes to CoreData
            self.saveContext()
            print("New provenances added and CoreData updated.")
            DispatchQueue.main.async {
                self.fetchLocalProvenances() // Refresh provenances from CoreData
            }
        }
    }
    
    func fetchLocalProvenances() {
        let request = NSFetchRequest<Provenance>(entityName: "Provenance")
        do {
            provenances = try context.fetch(request)
            print("Fetched \(provenances.count) provenances from Core Data.")
            provenances.enumerated().forEach { index, provenance in
                print("Index \(index) -> Provenance Item: id: \(provenance.id), title: \(provenance.title ?? "Unknown Title"), spatial: \(provenance.spatial ?? "Unknown Spatial")")
            }
        } catch let error as NSError {
            print("Error fetching provenances from Core Data: \(error), \(error.userInfo)")
        }
    }
    
    // Topic Methods
    func fetchTopicsFromAPI(completion: @escaping () -> Void = {}) {
        print("Fetching topics from API...")
        TopicService.fetchTopics { [weak self] topics in
            guard let self = self, let topics = topics else {
                print("Failed to fetch topics or topics were nil.")
                return
            }
            DispatchQueue.main.async {
                self.updateTopicsCoreData(with: topics) {
                    print("Topics fetched and processed.")
                    completion()
                }
            }
        }
    }
    
    
    func updateTopicsCoreData(with topics: [TopicItem], completion: @escaping () -> Void = {}) {
        context.perform {
            // Delete all existing topics first
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: Topic.fetchRequest())
            do {
                try self.context.execute(deleteRequest)
                print("All existing topics deleted.")
            } catch {
                print("Error deleting existing topics: \(error)")
            }

            // Add new topics from the fetched data
            for topicItem in topics {
                let newTopic = Topic(context: self.context)
                newTopic.id = Int32(topicItem.id)
                newTopic.title = topicItem.title
                newTopic.topicDescription = topicItem.topicDescription  // Set the new property
                newTopic.questionIDs = topicItem.questionIDs as NSArray
            }

            // Save changes to CoreData
            self.saveContext()
            print("New topics added and CoreData updated.")
            DispatchQueue.main.async {
                self.fetchLocalTopics() // Refresh topics from CoreData
                completion()
            }
        }
    }

    
    func fetchLocalTopics() {
        let request = NSFetchRequest<Topic>(entityName: "Topic")
        do {
            topics = try context.fetch(request)
            print("Fetched \(topics.count) topics from Core Data.")
            topics.enumerated().forEach { index, topic in
                let questionIDs = (topic.questionIDs as? [Int]) ?? []
                print("Index \(index) -> Topic Item: id: \(topic.id), title: \(topic.title ?? "Unknown Title"), description: \(topic.topicDescription ?? "Unknown Description"), questionIDs: \(questionIDs)")
            }
        } catch let error as NSError {
            print("Error fetching topics from Core Data: \(error), \(error.userInfo)")
        }
    }
    
    // Question related methods
    func fetchQuestionsFromAPI(completion: @escaping () -> Void) {
        QuestionService.fetchQuestions { [weak self] questions in
            guard let self = self, let questions = questions else {
                completion()  // Call completion even if there are no questions
                return
            }
            self.updateQuestionsCoreData(with: questions, completion: completion)
        }
    }

    func updateQuestionsCoreData(with questions: [QuestionItem], completion: @escaping () -> Void) {
        context.perform {
            
            // Delete all existing videos first
             QuestionService.deleteExistingVideos()
            
            // Delete all existing questions first
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: Question.fetchRequest())
            do {
                try self.context.execute(deleteRequest)
                print("All existing questions deleted.")
            } catch {
                print("Error deleting existing questions: \(error)")
            }

            
            let group = DispatchGroup()  // Create a group to track multiple asynchronous operations

            for questionItem in questions {
                let questionRequest = NSFetchRequest<Question>(entityName: "Question")
                questionRequest.predicate = NSPredicate(format: "id == %d", questionItem.id)

                do {
                    let fetchedQuestions = try self.context.fetch(questionRequest)
                    let question = fetchedQuestions.first ?? Question(context: self.context)

                    question.id = Int32(questionItem.id)
                    question.title = questionItem.title

                    if let mediaID = questionItem.primaryMediaID {
                        group.enter()  // Enter the group before starting the async operation
                        QuestionService.fetchMediaDetails(questionID: Int(question.id), mediaID: mediaID) { localURL in
                            DispatchQueue.main.async {
                                question.localURL = localURL?.absoluteString
                                self.saveContext()  // Save the context after updating the local URL
                                group.leave()  // Leave the group after the async operation is complete
                            }
                        }
                    }
                } catch {
                    print("Failed to save context or fetch questions: \(error)")
                    group.leave()  // Ensure to leave the group in case of error to prevent deadlock
                }
            }

            group.notify(queue: .main) {
                completion()  // Call completion when all async operations are done
            }
        }
    }

    func fetchLocalQuestions() {
        let request = NSFetchRequest<Question>(entityName: "Question")
        do {
            questions = try context.fetch(request)
            questions.forEach { question in
                // Check if id is 0 which might be used as a default value indicating uninitialized or unknown
                let questionID = question.id != 0 ? String(question.id) : "Unknown ID"
                let questionTitle = question.title ?? "Unknown Title"
                let videoURL = question.localURL ?? "No Video"
                print("Question Item: id: \(questionID), title: \(questionTitle), videoURL: \(videoURL)")
            }
        } catch {
            print("Error fetching questions from Core Data: \(error)")
        }
    }


    
    // General Core Data saving
    private func saveContext() {
        do {
            try context.save()
            print("Core Data context has been successfully saved.")
        } catch {
            print("Failed to save Core Data context: \(error)")
        }
    }


}

extension AppState {
    func getSelectedProvenanceID() -> Int? {
        return AdminSettingsManager.shared.getSelectedProvenanceID()
    }
}

extension AppState {
    func refreshData(completion: @escaping () -> Void) {
        let group = DispatchGroup()

        group.enter()
        fetchProvenancesFromAPI {
            group.leave()
        }
        
        group.enter()
        fetchTopicsFromAPI {
            group.leave()
        }
        
        group.enter()
        fetchQuestionsFromAPI {
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("All data refreshed.")
            completion()
        }
    }
}


enum AppView {
case welcome, introVideo, keyboardInstructions, userDataInput, chooseTopic, cameraSettings, answerQuestion, confirmAnswer, thankYou, adminSettings, adminUpload
}
