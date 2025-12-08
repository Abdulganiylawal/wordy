//
//  AdaptiveNavBar.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//


import SwiftUI

struct AdaptiveNavBar<Content: View, ToolbarContent: View>: View {
    let showToolBar:Bool
    let showBackButton: Bool
    let onBack: (() -> Void)?
    let content: Content
    let toolbarContent: ToolbarContent
    
    init(
        showToolBar: Bool = true,
        showBackButton: Bool = false,
        onBack: (() -> Void)? = nil,
        @ViewBuilder toolbar: () -> ToolbarContent,
        @ViewBuilder content: () -> Content
    ) {
        self.showToolBar = showToolBar
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.toolbarContent = toolbar()
        self.content = content()
    }
    
    var body: some View {
            content
            .safeAreaInset(edge: .top) {
                if showToolBar{
                    ZStack {
                        VariableBlurView(maxBlurRadius: 10, direction: .blurredTopClearBottom)
                            .frame(height: 100)
                            .padding([.horizontal, .top], -90)
                            .allowsHitTesting(false)
                        
                        toolbarContent
                        
                        .padding(.horizontal)
                      
                        .background(
                            BlurredTopBackgroundView(height: 50, blurRadius: Tokens.backgroundBlur)
                        )
                        
                    }
                    
                    
                }
            }
    }
}

