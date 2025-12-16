//
//  CircleWithThreadView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//



import SwiftUI

struct CircleWithThreadView: View {
    let iconOrEmoji: String
    let isSF: Bool
    let color1: Color
    let color2: Color
    let showThread: Bool
    let size: CGFloat
    let sfSymbolColor: Color?
    
    @Environment(\.colorScheme) var colorScheme
    
    init(iconOrEmoji: String, isSF: Bool, color1: Color, color2: Color, showThread: Bool, size: CGFloat, sfSymbolColor: Color? = nil) {
        self.iconOrEmoji = iconOrEmoji
        self.isSF = isSF
        self.color1 = color1
        self.color2 = color2
        self.showThread = showThread
        self.size = size
        self.sfSymbolColor = sfSymbolColor
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                
                if isSF {
                    Image(systemName: iconOrEmoji)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size )
                        .foregroundStyle(color1)
                } else {
                    Text(iconOrEmoji)
                        .font(.system(size: size ))
                        
                }
            }
            .frame(width: size, height: size, alignment: .top)
            if showThread {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [color1, color2],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 1.5)
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        CircleWithThreadView(iconOrEmoji: "bolt.fill", isSF: true, color1: .blue, color2: .purple, showThread: true, size: 25, sfSymbolColor: .yellow)
        CircleWithThreadView(iconOrEmoji: "🚌", isSF: false, color1: .yellow, color2: .orange, showThread: true, size: 25)
        CircleWithThreadView(iconOrEmoji: "star.fill", isSF: true, color1: .green, color2: .mint, showThread: true, size: 25, sfSymbolColor: .orange)
        CircleWithThreadView(iconOrEmoji: "🚕", isSF: false, color1: .pink, color2: .red, showThread: true, size: 25)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)

}
