//
//  pickLetter.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 10/12/2025.
//

import SwiftUI

struct PickLetter: View {
    var transition: Namespace.ID
    @Binding var selectedLetter:String?
    @Binding var wantsToPickLetter: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var onAppear: Bool = false
    var body: some View {
        VStack {
            HStack{
                Spacer()
                
                Button {
                    withAnimation(Tokens.menuSpring) {
                        wantsToPickLetter = false
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(AppColors.iconInverted(colorScheme: colorScheme))
                        .bold()
                        .frame(width:44,height: 44,alignment: .trailing)
                           .contentShape(Rectangle())
                }
                .hapticFeedback(style: .soft)
                .buttonStyle(BouncyButton())

            }
            .opacity(onAppear ? 1 : 0)
            .scaleEffect(onAppear ? 1 : 0.5)
        
        }
        .padding(.horizontal)
        .frame(height: 250,alignment: .top)
        .frame(maxWidth: .infinity)
        .cardBackgroundWithTransitionStyle(radius: 25, transition: transition)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.25)) {
                onAppear = true
            }
        }   
    }
}

#Preview {
    @Previewable @Namespace var transition
    PickLetter(transition: transition, selectedLetter: .constant(nil), wantsToPickLetter: .constant(false))
}
