//
//  LoadingAnimation.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 15/12/2025.
//


//
//  LoadingAnimation.swift
//  Apollo
//
//  Created by Lawal Abdulganiy on 08/01/2025.
//


import SwiftUI


struct LoadingAnimation: View {

    @State private var animate: Bool = false
    @State private var info = ["Leave the app open."]
    @State private var showingText: String = ""
    @State private var message:String
    var color:Color
    init(message:String,color:Color) {
        self.message = message
        self.color = color
    }
    
    var body: some View {
        ZStack(alignment:.center) {
            
            Color.black
                .opacity(0.2)
                .ignoresSafeArea()
               
                if animate {
                    Text(showingText)
                        .customAttribute(EmphasisAttribute())
                        .customTextStyle(color: color, size: 18, weight: .bold)
//                        .foregroundStyle(.red.gradient)
                        .transition(TextTransition())
                
                        .frame(maxWidth: .infinity,alignment: .center)
                        .multilineTextAlignment(.center)
                    
                }
         
        }
        .onAppear {
            
            startLoadingAnimation()
            
            
        }
    }
    
    private func startLoadingAnimation() {
        
        showingText = message
        withAnimation {
            animate = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                animate = false
                showingText = ""
            }
        }
     
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                animate = true
                showingText = "Leave the app open"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            resetAndRepeatAnimation()
            
        }
        
        
    }
    
    private func resetAndRepeatAnimation() {
        withAnimation {
            animate = false
            showingText = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                startLoadingAnimation()
            }
            
        }
        
    }
}

#Preview {
    @Previewable @Environment(\.colorScheme)  var colorScheme
    LoadingAnimation(message: "Getting Meaning", color: AppColors.textInverted(colorScheme: colorScheme))
}



