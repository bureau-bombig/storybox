//
//  TopicService.swift
//  Storybox
//
//  Created by User on 02.05.24.
//

import Foundation

// Define the structure for the items the API will return
struct TopicAPIResponse: Decodable {
    let items: [TopicItem]
}

struct TopicItem: Decodable {
    let id: Int
    let title: String
    let topicDescription: String
    let questionIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case id = "o:id"
        case title = "o:title"
        case descriptions = "dcterms:description"
        case questionIDs = "dcterms:relation"
    }
    
    enum RelationKeys: String, CodingKey {
        case valueResourceID = "value_resource_id"
    }

    enum DescriptionKeys: String, CodingKey {
        case value = "@value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        // Handling topicDescription
        var descriptionArray = try container.nestedUnkeyedContainer(forKey: .descriptions)
        var descriptionText = "No description provided"
        while !descriptionArray.isAtEnd {
            let descriptionContainer = try descriptionArray.nestedContainer(keyedBy: DescriptionKeys.self)
            descriptionText = try descriptionContainer.decode(String.self, forKey: .value)
            break // Assuming we only care about the first description if there are multiple
        }
        topicDescription = descriptionText
        // Handling questionIDs
        var questionsArray = try container.nestedUnkeyedContainer(forKey: .questionIDs)
        var questions: [Int] = []
        while !questionsArray.isAtEnd {
            let questionContainer = try questionsArray.nestedContainer(keyedBy: RelationKeys.self)
            let questionID = try questionContainer.decode(Int.self, forKey: .valueResourceID)
            questions.append(questionID)
        }
        questionIDs = questions
    }
}
// TopicService to handle fetching of topics from the API
class TopicService {
    static func fetchTopics(completion: @escaping ([TopicItem]?) -> Void) {
        let urlString = "https://archiv.freiheitsarchiv.de/api/items?resource_class_id=177"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode([TopicItem].self, from: data)
                DispatchQueue.main.async {
                    print(apiResponse)
                    completion(apiResponse)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
