//
//  PersistentStore.swift
//  Storybox
//
//  Created by User on 01.05.24.
//

import CoreData

class PersistentStore {
    static let shared = PersistentStore()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "StoryboxModel")  // Make sure the name matches your Core Data Model
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
