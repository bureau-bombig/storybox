//
//  ProvenanceService.swift
//  Storybox
//
//  Created by User on 01.05.24.
//

import Foundation



struct ProvenanceAPIResponse: Codable {
    let items: [ProvenanceItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"  // This assumes the JSON array is wrapped in an "items" key, which might not be the case.
    }
}

struct ProvenanceItem: Codable {
    let id: Int
    let titleDetails: [Detail]
    let spatialDetails: [Detail]
    
    enum CodingKeys: String, CodingKey {
        case id = "o:id"
        case titleDetails = "dcterms:title"
        case spatialDetails = "dcterms:spatial"
    }
}

struct Detail: Codable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "@value"
    }
}

class ProvenanceService {
    static func fetchProvenances(completion: @escaping ([ProvenanceItem]?) -> Void) {
        print("Fetching provenances from API...")
        guard let url = URL(string: "https://archiv.freiheitsarchiv.de/api/items?resource_class_id=175") else {
            print("Failed to fetch or items were nil")
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
                let items = try decoder.decode([ProvenanceItem].self, from: data)
                DispatchQueue.main.async {
                    print(items)
                    completion(items)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
