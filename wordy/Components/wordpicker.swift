//
//  wordpicker.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 10/12/2025.
//

import SwiftUI

struct Wordpicker: View {
    @Environment(DbStore.self) var dbStore
    @Bindable var wordStore:WordStore
    @Environment(\.colorScheme) var colorScheme
    @Binding var showNextView: Bool
    @State private var selectedLetter: String?
    @Namespace var transition
    @State private var wantsToPickLetter:Bool = false
    @State private var onAppear: Bool = false
    init(wordStore: WordStore, showNextView: Binding<Bool>) {
        self.wordStore = wordStore
        self._showNextView = showNextView
    }
    
    var body: some View {
        HStack(alignment:.bottom) {
            CircularButton(icon: "clock.arrow.circlepath", action: {
                withAnimation(Tokens.menuSpring) {
                    wantsToPickLetter = true
                }
            })
            
            if wantsToPickLetter {
                PickLetter(transition: transition, selectedLetter: $selectedLetter, wantsToPickLetter: $wantsToPickLetter)
            } else {
                HStack {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(dbStore.meanings, id: \.word) { meaning in
                                Button {
                                    withAnimation {
                                        wordStore.words = meaning
                                        showNextView = true
                                    }
                                } label: {
                                    Text(meaning.word)
                                        .customTextStyle(color: wordStore.words?.word == meaning.word ? AppColors.textInverted(colorScheme: colorScheme) : AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                                }
                                .hapticFeedback(style: .soft)
                                .buttonStyle(BouncyButton())
                                .applyHorizontalScrollTransition()
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .cardBackgroundWithTransitionStyle(radius: 25, transition: transition)
                    
                }
            }
        }
        .transition(.scale(scale: 1).combined(with: .opacity))
    }
}

#Preview {
    Wordpicker(wordStore: WordStore(localLLmService: LocalLLmService()), showNextView: .constant(false))
        .environment(DbStore(.shared))
}



struct CardBackgroundWithTransition: ViewModifier {
    let radius: CGFloat
    
    let transition: Namespace.ID?
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        
        content
            .background(
                ZStack {
                    ConcentricRectangle()
                        .fill( .clear)
                        .glassEffect(.clear,in: .rect(cornerRadius: radius, style: .continuous))
                }
                    .containerShape(.rect(cornerRadius: radius, style: .continuous))
                    .modifier(OptionalMatchedGeometry(id: "transition", namespace: transition))
            )
        
            .mask(
                ConcentricRectangle()
                    .fill(.clear)
                    .glassEffect(.clear.tint(.clear),in: .rect(cornerRadius: radius, style: .continuous))
                    .modifier(OptionalMatchedGeometry(id: "mask", namespace: transition))
            )
        
        
    }
}

struct OptionalMatchedGeometry: ViewModifier {
    let id: String
    let namespace: Namespace.ID?
    
    func body(content: Content) -> some View {
        if let namespace = namespace {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content
        }
    }
}

