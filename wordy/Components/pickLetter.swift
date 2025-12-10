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
    var body: some View {
        VStack {
            
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .cardBackgroundWithTransitionStyle(radius: 20, transition: transition)
    }
}

#Preview {
    @Previewable @Namespace var transition
    PickLetter(transition: transition, selectedLetter: .constant(nil))
}
