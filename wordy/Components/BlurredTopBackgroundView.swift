//
//  BlurredTopBackgroundView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//



import SwiftUI


let colorPalette: [UIColor] = [
    .systemRed, .systemBlue, .systemGreen, .systemYellow,
    .systemOrange, .systemPurple, .systemTeal, .systemPink,
    .systemIndigo, .cyan, .magenta, .systemMint,
    .systemCyan, .systemBrown,
    UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0),
    UIColor(red: 0.5, green: 1.0, blue: 0.0, alpha: 1.0),
    UIColor(red: 1.0, green: 0.5, blue: 0.4, alpha: 1.0),
    UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0),
    UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0),
    UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0),
    UIColor(red: 0.3, green: 0.8, blue: 0.7, alpha: 1.0),
    UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0),
    UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0),
    UIColor(red: 1.0, green: 0.7, blue: 0.0, alpha: 1.0),
    UIColor(red: 0.5, green: 1.0, blue: 0.0, alpha: 1.0)
]

struct BlurredTopBackgroundView: View {
    @State private var gradientColors: [Color] = []
    
    @Environment(\.colorScheme) var colorScheme
    
    
    
    
    var height: CGFloat
    var blurRadius: CGFloat
    
    var body: some View {
        ZStack {
//            Rectangle()
            
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).colorEffect( ShaderLibrary.parameterizedNoise(
                .float(0.4),   // intensity
                .float(0.5),  // frequency
                .float(0.5)    // opacity
            ))
            
            .frame(maxWidth: .infinity)
            
            .frame(height: height )
            .blur(radius: blurRadius)
            
            .ignoresSafeArea()
            .blendMode(.screen)
            
            
        }
        
        .onAppear {
            gradientColors = getRandomGradientColors()
        }
    }
    
    private func getRandomGradientColors() -> [Color] {
        let selectedPalette = colorPalette
        let uiColors = (1...2).compactMap { _ in selectedPalette.randomElement() }
        return uiColors.map { Color($0) }
    }
}
