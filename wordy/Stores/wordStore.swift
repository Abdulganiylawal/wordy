//
//  wordStore.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import Foundation
import SwiftUI

@Observable
@MainActor
class WordStore {
    @ObservationIgnored
    private var wordService = WordService()
    var loading: Loading = .na
    var words: [WordModel] = []
    var searchWord: String = ""

    func fetchWords(_ word: String) async {
        do {
            updateLoading(status: .loading)
            let (words, response) = try await wordService.getWords(word)
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    self.words = words
                    debugLog("Words fetched successfully: \(words)")
                } else {
                    throw NSError(domain: "Invalid response", code: response.statusCode)
                }
            }
            updateLoading(status: .finished)
        } catch {
            updateLoading(status: .failed)
            debugLog("Error fetching words: \(error)")
        }
    }
}


extension WordStore {
   func updateLoading(status: Loading) {
        withAnimation {
            self.loading = status
        }
    }
}
