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
        Group {
            if wantsToPickLetter {
                PickLetter(transition: transition, selectedLetter: $selectedLetter, wantsToPickLetter: $wantsToPickLetter)
            } else {
                HStack {
                    Button {
                        withAnimation(Tokens.menuSpring) {
                            wantsToPickLetter = true
                        }
                    } label: {
                        if selectedLetter == nil {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundStyle(AppColors.iconInverted(colorScheme: colorScheme))
                            .bold()
                            .padding()
                      .contentShape(Rectangle())
                            
                        } else {
                            Text(selectedLetter ?? "")
                                .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .bold)
                                .padding()
                                  .contentShape(Rectangle()) 
                        }
                    }
                    .frame(width: 50,height: 44,alignment: .leading)
                    .hapticFeedback(style: .soft)
                    .buttonStyle(BouncyButton())
                  

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
                    }
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .cardBackgroundWithTransitionStyle(radius: 25, transition: transition)
           
            }
        }
        .transition(.scale(scale: 1).combined(with: .opacity))
    }
}

#Preview {
    Wordpicker(wordStore: WordStore(), showNextView: .constant(false))
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

