//
//  ExampleView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//

import SwiftUI

struct ExampleView: View {
    var examples: [String]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if !examples.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text("Examples")
                    .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                
                
                    ForEach(examples, id: \.self) { example in
                        Text(example)
                            .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .medium)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 1)
                    }
                
            }
        }
    }
}

#Preview {
    ExampleView(examples: ["This is an example sentence.", "Here's another example."])
}
