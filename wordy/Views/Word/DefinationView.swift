//
//  DefinationView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//

import SwiftUI

struct DefinationView: View {
    var definition: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if !definition.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text("Definition")
                    .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                
                Text(definition)
                    .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .medium)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    DefinationView(definition: "A statement of the exact meaning of a word")
}
