//
//  ResultView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import SwiftUI

struct ResultView: View {
    @Bindable var wordStore:WordStore
    @Environment(\.colorScheme) var colorScheme
    var word: MeaningModel
    @State private var onAppear: Bool = false
    var body: some View {
        LazyVStack(alignment: .leading,spacing: 10) {
            
            PhoneticView(phonetics: word.phonetics ?? [], typeOfWord: word.definitions.typeOfWord)

            DefinationView(definition: word.definitions.definition)
            
            SynonymView(synonyms: word.definitions.synonyms)
            
            AntonymView(antonyms: word.definitions.antonyms)
            
            ExampleView(examples: word.definitions.example)
                
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                onAppear = true
            }
        }
    }
}

#Preview {
    var model = MeaningModel(word: "Hello", partOfSpeech: nil, phonetics: [Phonetics(text: "Phonetic", audio: "https://example.com/audio.mp3")], definitions: AIDictionaryModel(definition: "Definition", typeOfWord: "Type of Word", synonyms: ["Synonym 1", "Synonym 2"], antonyms: ["Antonym 1", "Antonym 2"], example: ["Example 1", "Example 2"]))

    ResultView(wordStore: WordStore(), word: model)
}
