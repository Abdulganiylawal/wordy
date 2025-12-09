//
//  AntonymView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//

import SwiftUI

struct AntonymView: View {
    var antonyms: [String]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if !antonyms.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text("Antonyms")
                    .customTextStyle(color: AppColors.textMute(colorScheme: colorScheme), size: 16, weight: .medium)
                
              
                    ForEach(antonyms, id: \.self) { antonym in
                        Text(antonym)
                            .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 18, weight: .medium)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 1)
                          
                    }
                
            }
        }
    }
}

#Preview {
    AntonymView(antonyms: ["opposite", "contrary", "reverse"])
}
