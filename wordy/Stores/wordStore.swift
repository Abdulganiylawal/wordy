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
    var partOfSpeech: String = ""
    var words: MeaningModel?
    var searchWord: String = ""


    func getWordMeaning(_ word: String) async {
        do {
            updateLoading(status: .loading)
            let (fromDic, fromAi) = try await wordService.getMeaning(word)
            words = MeaningModel(partOfSpeech: fromDic.first?.phonetic, phonetics: fromDic.first?.phonetics, definitions: fromAi)
            debugLog(words)
            updateLoading(status: .finished)
        } catch {
            updateLoading(status: .failed)
            debugLog("Error getting word meaning: \(error)")
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
