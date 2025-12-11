//
//  Untitled.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//



import SwiftUI

struct WordView: View {
    @State private var wordStore = WordStore()
    @Environment(DbStore.self) var dbStore
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(KeyboardManager.self) var keyboardManager
    @State private var blurView: Bool = false
    @State private var currentPageIndex: Int = 0
    @State private var showNextView = false
    @State private var scrollPosition: Int? = nil
    @State private var showSettingsView = false
    @Environment(LocalLLmService.self) var localLLM
    
    var body: some View {
        GeometryReader { geometry in
            mainContentView(geometry: geometry)
                .background(AppColors.background(colorScheme: colorScheme))
                .onTapGesture {
                    keyboardManager.dismissKeyboard()
                }
                .overlay(alignment: .center) {
                    textFieldOverlay
                }
                .safeAreaBar(edge: .top) {
                    topBarContent
                }
                .safeAreaInset(edge: .bottom) {
                    ZStack(alignment: .bottom){
                        VariableBlurView(maxBlurRadius: 5, direction: .blurredBottomClearTop)
                            .frame(height: 89)
                            .padding([.horizontal, .bottom], -50)
                        
                        
                        bottomBarContent
                    }
                }
                .onChange(of: wordStore.words) { oldValue, newValue in
                    handleWordsChange( newValue: newValue)
                }
                .onChange(of: wordStore.loading) {
                    handleLoadingChange()
                }
                .sheet(isPresented: $showSettingsView) {
                    NavigationStack {
                        SettingsView()
                            
                    }
                }
            
        }
    }
    
    @ViewBuilder
    private func mainContentView(geometry: GeometryProxy) -> some View {
        ScrollView {
            if showNextView && wordStore.words != nil {
                ResultView(wordStore: wordStore, word: wordStore.words!)
                    .padding(.top,20)
                    .padding(.bottom,80)
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    
    @ViewBuilder
    private var topBarContent: some View {
        HStack {
            Group {
                if showNextView {
                    textWithSubscript(
                        wordStore.searchWord.isEmpty ? wordStore.words?.word ?? "" : wordStore.searchWord,
                        color: AppColors.textInverted(colorScheme: colorScheme),
                        size: 28,
                        weight: .bold,
                        subscriptWord: ""
                    )
                    
                    
                    Spacer()
                    closeButton
                } else {
                    Spacer()
                    menuButtons
                }
            }
            .transition(.blurReplace)
        }
        .padding(.horizontal)
        .background(
            BlurredTopBackgroundView(height: 40, blurRadius: Tokens.backgroundBlur)
        )
    }
    
    @ViewBuilder
    private var closeButton: some View {
        CircularButton(icon: "xmark") {
            withAnimation {
                wordStore.words = nil
                showNextView = false
                blurView = false
                scrollPosition = nil
                currentPageIndex = 0
            }
        }
    }
    
    @ViewBuilder
    private var menuButtons: some View {
        CircularButton(icon: "brain.fill") {
            //
        }
        .blur(radius: blurView ? 10 : 0)
        .animation(.easeInOut, value: blurView)
        .padding(Tokens.Spacing.lg)
        
        CircularButton(icon: "gear") {
            showSettingsView = true
        }
        .blur(radius: blurView ? 10 : 0)
        .animation(.easeInOut, value: blurView)
    }
    
    @ViewBuilder
    private var textFieldOverlay: some View {
        if !showNextView {
            VStack {
                Spacer()
                TextField("", text: $wordStore.searchWord)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 28, weight: .medium)
                    .placeholder(when: wordStore.searchWord.isEmpty, alignment: .center) {
                        Text("Enter Word")
                            .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 25, weight: .medium)
                    }
                Spacer()
            }
            .padding(.horizontal)
            .blur(radius: blurView ? 10 : 0)
            .animation(.easeInOut, value: blurView)
        }
    }
    
    @ViewBuilder
    private var bottomBarContent: some View {
        
        ZStack{
            BlurredTopBackgroundView(height: 40, blurRadius: Tokens.backgroundBlur)
            HStack(alignment: .bottom){
                Wordpicker( wordStore: wordStore,showNextView: $showNextView)
                if !showNextView {
                    searchButton
                }
                
            }
        }
        
        .padding(.horizontal)
        .opacity(keyboardManager.isKeyboardVisible ? 0 : 1)
        .animation(.easeInOut, value: keyboardManager.isKeyboardVisible)
    }
    
    @ViewBuilder
    private var searchButton: some View {
        CircularButton(icon: "magnifyingglass", buttonColor: .blue, useButtonColor: true) {
            Task {
                if let meaning = await wordStore.getWordMeaning(wordStore.searchWord) {
                    do {
                        let localMeaning = try MeaningModel.toLocalMeaningModel(meaning: meaning)
                        await dbStore.saveMeaning(localMeaning)
                    } catch {
                        debugLog("Error converting meaning to local meaning: \(error.localizedDescription)")
                    }
                }
            }
        }
        
    }
    
    
    private func handleWordsChange( newValue: MeaningModel?) {
        if newValue != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    blurView = false
                    showNextView = true
                    
                }
            }
        }
    }
    
    private func handleLoadingChange() {
        withAnimation {
            isLoading = wordStore.loading == .loading
            if isLoading {
                blurView = true
            } else if wordStore.loading == .failed {
                showNextView = false
                blurView = false
            }
        }
    }
    
    
    
    @ViewBuilder
    private func textWithSubscript(_ text: String, color: Color, size: CGFloat, weight: Font.Weight, subscriptWord: String) -> some View {
        // Example: Add subscript to the last character
        // You can customize this to target specific parts of the text
        if text.count > 0 {
            let mainText = text
            let subscriptText = subscriptWord
            
            return (
                Text(mainText)
                    .font(.system(size: size, weight: weight, design: .rounded))
                    .foregroundColor(color)
                +
                Text(subscriptText)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                
                    .foregroundColor(color)
                    .baselineOffset(size * 0.30)
                
            )     .contentTransition(.numericText())
        } else {
            return Text(text)
                .font(.system(size: size, weight: weight, design: .rounded))
                .foregroundColor(color)
                .contentTransition(.identity)
        }
    }
    
}

struct PageIndicatorCircle: View {
    let index: Int
    let currentPageIndex: Int
    let colorScheme: ColorScheme
    
    private var isCurrentPage: Bool {
        index == currentPageIndex
    }
    
    private var circleColor: Color {
        isCurrentPage ? AppColors.textInverted(colorScheme: colorScheme) : AppColors.textMute(colorScheme: colorScheme)
    }
    
    private var circleSize: CGFloat {
        isCurrentPage ? 8 : 6
    }
    
    var body: some View {
        Circle()
            .fill(circleColor)
            .frame(width: circleSize, height: circleSize)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPageIndex)
    }
}

#Preview {
    WordView()
        .environment(KeyboardManager())
        .environment(DbStore(.empty()))
}
