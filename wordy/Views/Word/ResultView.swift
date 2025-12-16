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
    @State private var showPhoneticsView = true
    @State private var onAppear: Bool = false
    var body: some View {
        LazyVStack(alignment: .leading,spacing: 0) {
            
            HStack(alignment: .top) {
                CircleWithThreadView(iconOrEmoji: "circle.fill", isSF: true, color1: AppColors.textDisabled(colorScheme: colorScheme), color2: AppColors.textDisabled(colorScheme: colorScheme), showThread: true, size: 15)
                
                VStack(alignment: .leading,spacing: 2) {
                    Text("Type of word")
                        .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                    
                    Text(word.definitions.typeOfWord)
                        .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .medium)
                 
                 
                        .multilineTextAlignment(.leading)
                        .padding(.bottom,5)
                     
                }
                .padding(.bottom,5)
               
            }
            
            if showPhoneticsView{
                HStack(alignment: .top) {
                    CircleWithThreadView(iconOrEmoji: "circle.fill", isSF: true, color1: AppColors.textDisabled(colorScheme: colorScheme), color2: AppColors.textDisabled(colorScheme: colorScheme), showThread: true, size: 15)
                    
                    PhoneticView(phonetics: word.phonetics ?? [], typeOfWord: word.definitions.typeOfWord,showView: $showPhoneticsView)
                }
                
            }
            
           
            
            
            HStack(alignment: .top) {
                CircleWithThreadView(iconOrEmoji: "circle.fill", isSF: true, color1: AppColors.textDisabled(colorScheme: colorScheme), color2: AppColors.textDisabled(colorScheme: colorScheme), showThread: true, size: 15)
                
                DefinationView(definition: word.definitions.definition)
                    .padding(.bottom,5)
            }
            
            HStack(alignment: .top) {
                CircleWithThreadView(iconOrEmoji: "circle.fill", isSF: true, color1: AppColors.textDisabled(colorScheme: colorScheme), color2: AppColors.textDisabled(colorScheme: colorScheme), showThread: true, size: 15)
                
                SynonymView(synonyms: word.definitions.synonyms)
              
            }
            
            HStack(alignment: .top) {
                CircleWithThreadView(iconOrEmoji: "circle.fill", isSF: true, color1: AppColors.textDisabled(colorScheme: colorScheme), color2: AppColors.textDisabled(colorScheme: colorScheme), showThread: true, size: 15)
                
                AntonymView(antonyms: word.definitions.antonyms)
                    
            }
            
            HStack(alignment: .top) {
                CircleWithThreadView(iconOrEmoji: "circle.fill", isSF: true, color1: AppColors.textDisabled(colorScheme: colorScheme), color2: AppColors.textMute(colorScheme: colorScheme), showThread: false, size: 15)
                
                ExampleView(examples: word.definitions.example)
                   
            }
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
    
    ResultView(wordStore: WordStore(localLLmService: LocalLLmService()), word: model)
}
