//
//  wordService.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import Foundation

struct DictionaryEntry: Decodable {
    let word: String
}

class WordService {
    
    func getWords(_ word: String) async throws -> ([WordModel], URLResponse?) {
        let urlString = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 100)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        let wordModel = try JSONDecoder().decodeLoggingErrors([WordModel].self, from: data)
        return (wordModel, response)
    }
}
