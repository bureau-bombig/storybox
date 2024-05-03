//
//  QuestionService.swift
//  Storybox
//
//  Created by User on 02.05.24.
//

import Foundation

// Define the structure for the API response for questions
struct QuestionAPIResponse: Decodable {
    let items: [QuestionItem]
}

struct QuestionItem: Decodable {
    let id: Int
    let title: String
    let primaryMediaID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "o:id"
        case title = "o:title"
        case primaryMedia = "o:primary_media"
    }

    enum PrimaryMediaKeys: String, CodingKey {
        case id = "o:id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        let primaryMediaContainer = try? container.nestedContainer(keyedBy: PrimaryMediaKeys.self, forKey: .primaryMedia)
        primaryMediaID = try primaryMediaContainer?.decodeIfPresent(Int.self, forKey: .id)
    }
}

struct MediaResponse: Decodable {
    let originalURL: String

    enum CodingKeys: String, CodingKey {
        case originalURL = "o:original_url"
    }
}


class QuestionService {
    static let videoSubfolder = "question_vids"

    static func fetchQuestions(completion: @escaping ([QuestionItem]?) -> Void) {
        let urlString = "https://archiv.freiheitsarchiv.de/api/items?resource_class_id=174"
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
                let apiResponse = try decoder.decode([QuestionItem].self, from: data)
                DispatchQueue.main.async {
                    completion(apiResponse)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

    static func deleteExistingVideos() {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(videoSubfolder)

        // Delete the video directory to clear all old videos
        try? fileManager.removeItem(at: directoryURL)
        print("All existing videos deleted.")
    }

    static func fetchMediaDetails(questionID: Int, mediaID: Int, completion: @escaping (URL?) -> Void) {
        let urlString = "https://archiv.freiheitsarchiv.de/api/media/\(mediaID)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching media data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                if let mediaResponse = try? decoder.decode(MediaResponse.self, from: data),
                   let videoURL = URL(string: mediaResponse.originalURL) {
                    downloadVideo(questionID: questionID, url: videoURL, completion: completion)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    static func downloadVideo(questionID: Int, url: URL, completion: @escaping (URL?) -> Void) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL else {
                print("Video download failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            // Save the video file to the permanent directory with a descriptive filename
            let permanentURL = saveDownloadedFileToLocalDirectory(questionID: questionID, localURL: localURL)
            completion(permanentURL)
        }
        downloadTask.resume()
    }

    private static func saveDownloadedFileToLocalDirectory(questionID: Int, localURL: URL) -> URL? {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(videoSubfolder)
        
        // Ensure the directory exists
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)

        let newFileName = "question_video_\(questionID).mp4"
        let destinationURL = directoryURL.appendingPathComponent(newFileName)

        // Remove any existing file at the destination
        try? fileManager.removeItem(at: destinationURL)

        do {
            // Move the file from the temporary location to the permanent location
            try fileManager.moveItem(at: localURL, to: destinationURL)
            return destinationURL
        } catch {
            print("Failed to move downloaded file: \(error)")
            return nil
        }
    }
}



/*
// Service to handle fetching of questions and media details from the API
class QuestionService {
    static func fetchQuestions(completion: @escaping ([QuestionItem]?) -> Void) {
        let urlString = "https://archiv.freiheitsarchiv.de/api/items?resource_class_id=174"
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
                let apiResponse = try decoder.decode([QuestionItem].self, from: data)
                DispatchQueue.main.async {
                    completion(apiResponse)
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

    static func fetchMediaDetails(questionID: Int, mediaID: Int, completion: @escaping (URL?) -> Void) {
        let urlString = "https://archiv.freiheitsarchiv.de/api/media/\(mediaID)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching media data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                if let mediaResponse = try? decoder.decode(MediaResponse.self, from: data),
                   let videoURL = URL(string: mediaResponse.originalURL) {
                    downloadVideo(questionID: questionID, url: videoURL, completion: completion)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }

    static func downloadVideo(questionID: Int, url: URL, completion: @escaping (URL?) -> Void) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL else {
                print("Video download failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            // Save the video file to the permanent directory with a descriptive filename
            let permanentURL = saveDownloadedFileToLocalDirectory(questionID: questionID, localURL: localURL)
            completion(permanentURL)
        }
        downloadTask.resume()
    }

    private static func saveDownloadedFileToLocalDirectory(questionID: Int, localURL: URL) -> URL? {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newFileName = "question_video_\(questionID).mp4"
        let destinationURL = directoryURL.appendingPathComponent(newFileName)

        // Remove any existing file at the destination
        try? fileManager.removeItem(at: destinationURL)

        do {
            // Move the file from the temporary location to the permanent location
            try fileManager.moveItem(at: localURL, to: destinationURL)
            return destinationURL
        } catch {
            print("Failed to move downloaded file: \(error)")
            return nil
        }
    }

}
*/
