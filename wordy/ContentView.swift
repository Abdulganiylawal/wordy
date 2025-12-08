//
//  ContentView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        AdaptiveNavBar {
            HStack{
                Text("Testing")
                Spacer()
            }
        } content: {
            VStack {
                
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(AppColors.background(colorScheme: colorScheme))
        }
       
    }
}

#Preview {
    ContentView()
}
