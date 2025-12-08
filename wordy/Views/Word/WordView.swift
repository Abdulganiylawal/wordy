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
    @State private var blurView: Bool = false
    @State private var currentPageIndex: Int = 0
    @State private var showNextView = false
    @State private var scrollPosition: Int? = nil
    
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
                .safeAreaBar(edge: .bottom) {
                    bottomBarContent
                }
                .onChange(of: wordStore.words) { oldValue, newValue in
                    handleWordsChange(oldValue: oldValue, newValue: newValue)
                }
                .onChange(of: wordStore.loading) {
                    handleLoadingChange()
                }
                .onChange(of: wordStore.words.count) { oldValue, newValue in
                    handleWordsCountChange(oldValue: oldValue, newValue: newValue)
                }
        }
    }
    
    @ViewBuilder
    private func mainContentView(geometry: GeometryProxy) -> some View {
        ScrollView {
            if showNextView {
                horizontalScrollView(geometry: geometry)
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func horizontalScrollView(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(Array(wordStore.words.enumerated()), id: \.element.id) { index, word in
                    ResultView(wordStore: wordStore, word: word)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .id(index)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.paging)
        .onChange(of: scrollPosition) { oldValue, newValue in
            if let newValue = newValue {
                withAnimation(.easeInOut) {
                    currentPageIndex = newValue
                }
            }
        }
        .onAppear {
            if scrollPosition == nil && showNextView {
                scrollPosition = 0
            }
        }
        .transition(.blurReplace)
        .animation(.easeInOut, value: showNextView)
    }
    
    @ViewBuilder
    private var topBarContent: some View {
        HStack {
            Group {
                if showNextView {
                    textWithSubscript(
                        wordStore.searchWord,
                        color: AppColors.textInverted(colorScheme: colorScheme),
                        size: 28,
                        weight: .bold,
                        subscriptWord: " \(currentPageIndex + 1)/\(wordStore.words.count)"
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
            BlurredTopBackgroundView(height: 100, blurRadius: Tokens.backgroundBlur)
        )
    }
    
    @ViewBuilder
    private var closeButton: some View {
        CircularButton(icon: "xmark") {
            withAnimation {
                wordStore.words = []
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
            //
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
        HStack {
            if !showNextView {
                Spacer()
                searchButton
            } else {
                pageIndicators
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var searchButton: some View {
        CircularButton(icon: "magnifyingglass", buttonColor: .blue, useButtonColor: true) {
            Task {
                await wordStore.fetchWords(wordStore.searchWord)
            }
        }
        .opacity(keyboardManager.isKeyboardVisible ? 0 : 1)
        .animation(.easeInOut, value: keyboardManager.isKeyboardVisible)
    }
    
    @ViewBuilder
    private var pageIndicators: some View {
        ForEach(0..<wordStore.words.count, id: \.self) { index in
            PageIndicatorCircle(
                index: index,
                currentPageIndex: currentPageIndex,
                colorScheme: colorScheme
            )
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    private func handleWordsChange(oldValue: [WordModel], newValue: [WordModel]) {
        if !newValue.isEmpty {
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
    
    private func handleWordsCountChange(oldValue: Int, newValue: Int) {
        if newValue > 0 && oldValue == 0 {
            currentPageIndex = 0
            scrollPosition = 0
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
}
