//
//  Untitled.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//



import SwiftUI

struct WordView: View {
    @State private var wordStore = WordStore()
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(KeyboardManager.self) var keyboardManager
    var body: some View {
        ScrollView {
            
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(AppColors.background(colorScheme: colorScheme))
        .safeAreaInset(edge: .top) {
            ZStack {
                VariableBlurView(maxBlurRadius: 10, direction: .blurredTopClearBottom)
                    .frame(height: 100)
                    .padding([.horizontal, .top], -90)
                    .allowsHitTesting(false)
                HStack{
                    Spacer()
                    CircularButton(icon: "brain.fill") {
                        //
                    }
                    .padding(Tokens.Spacing.lg)
                    
                    CircularButton(icon: "gear") {
                        //
                    }
                }
                .padding(.horizontal)
                
                .background(
                    BlurredTopBackgroundView(height: 100, blurRadius: Tokens.backgroundBlur)
                )
            }
        }
        .onTapGesture {
            keyboardManager.dismissKeyboard()
        }
        .overlay(alignment: .center) {
            VStack{
                Spacer()
                
                TextField("", text: $wordStore.searchWord)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 28, weight: .medium)
                    .placeholder(when: wordStore.searchWord.isEmpty,alignment: .center) {
                        Text("Enter Word")
                            .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 25, weight: .medium)
                    }
                
                Spacer()
                HStack{
                    Spacer()
                    
                    CircularButton(icon: "magnifyingglass",buttonColor: .blue, useButtonColor: true ,action: {
                        Task {
                            await wordStore.fetchWords(wordStore.searchWord)
                        }
                    })
                    .opacity(keyboardManager.isKeyboardVisible ? 0 : 1)
                    .animation(.easeInOut, value: keyboardManager.isKeyboardVisible)
                }
            }
            .padding(.horizontal)
        }.onChange(of: wordStore.loading) {
            isLoading = wordStore.loading == .loading
        }
    }
}


#Preview {
    WordView()
        .environment(KeyboardManager())
}
