//
//  PrimaryButton.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//



import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    @Binding var isLoading: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        
                } else {
                    Text(title)
                        .customTextStyle(color: AppColors.lightColors.primaryNeutralWhite, size: Tokens.Scale.s300, weight: .semibold)
                        .contentTransition(.numericText())
                        
                       
                        
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isLoading ? AppColors.lightColors.backgroundSurfaceMute : AppColors.lightColors.primaryPrimaryDefault)
            .cornerRadius(Tokens.Radius.xxxl)
            .shadow(color:isLoading ? .clear : Tokens.Colors.Transparent.Black.b200, radius: 4, x: 0, y: 4)
            .animation(.spring, value: isLoading)
        }
        .buttonStyle(BouncyButton())
        .hapticFeedback(style: .light)
        .disabled(isLoading)
    }
}

#Preview {
    @Previewable @State var isLoading = false
    
    VStack(spacing: 20) {
        PrimaryButton(
            title: "Sign In",
            action: {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            },
            isLoading: $isLoading
        )
        
        PrimaryButton(
            title: "Loading...",
            action: {
                //
            },
            isLoading: .constant(true)
        )
    }
    .padding()
}
