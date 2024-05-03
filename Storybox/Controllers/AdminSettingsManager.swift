//
//  AdminSettingsManager.swift
//  Storybox
//
//  Created by User on 02.05.24.
//
import Foundation

class AdminSettingsManager {
    static let shared = AdminSettingsManager()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let selectedProvenanceID = "selectedProvenanceID"
        static let selectedTopicIDs = "selectedTopicIDs"
    }

    func saveSelectedProvenanceID(_ id: Int?) {
        if let id = id {
            defaults.set(id, forKey: Keys.selectedProvenanceID)
        } else {
            defaults.removeObject(forKey: Keys.selectedProvenanceID)
        }
    }

    func getSelectedProvenanceID() -> Int? {
        if let id = defaults.value(forKey: Keys.selectedProvenanceID) as? Int {
            return id
        }
        return nil
    }

    func saveSelectedTopicIDs(_ ids: [Int]) {
        defaults.set(ids, forKey: Keys.selectedTopicIDs)
    }

    func getSelectedTopicIDs() -> [Int] {
        return defaults.array(forKey: Keys.selectedTopicIDs) as? [Int] ?? []
    }

    func resetSettings() {
        defaults.removeObject(forKey: Keys.selectedProvenanceID)
        defaults.removeObject(forKey: Keys.selectedTopicIDs)
    }
}
