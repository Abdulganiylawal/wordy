//
//  SynonymView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//

import SwiftUI

struct SynonymView: View {
    var synonyms: [String]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if !synonyms.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text("Synonyms")
                    .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                
               
                    ForEach(synonyms, id: \.self) { synonym in
                        Text(synonym)
                            .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .medium)
               
                            .padding(.vertical, 1)
                            .multilineTextAlignment(.leading)
                            
                    }
                
            }
            .padding(.bottom,5)
        }
    }
}

#Preview {
    SynonymView(synonyms: ["equivalent", "alternative", "substitute"])
}
