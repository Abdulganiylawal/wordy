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
    var word: WordModel
    @State private var onAppear: Bool = false
    var body: some View {
        LazyVStack(alignment: .leading,spacing: 0) {

                PhoneticView(phonetics: word.phonetics ?? [])
                
                
            
         
            
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

//#Preview {
//    ResultView(wordStore: WordStore(), word: WordModel(word: "Hello"))
//}
