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


    func getWordMeaning(_ word: String) async -> MeaningModel? {
        do {
            updateLoading(status: .loading)
            let (fromDic, fromAi) = try await wordService.getMeaning(word)
            let foundPhonetics = fromDic.first?.phonetics?.compactMap { $0.audio != nil ? $0 : nil }
            words = MeaningModel(partOfSpeech: fromDic.first?.phonetic, phonetics: foundPhonetics, definitions: fromAi)
            debugLog(words)
            updateLoading(status: .finished)
            return words
        } catch {
            updateLoading(status: .failed)
            debugLog("Error getting word meaning: \(error)")
        }
        return nil
    }
}


extension WordStore {
   func updateLoading(status: Loading) {
        withAnimation {
            self.loading = status
        }
    }
}
