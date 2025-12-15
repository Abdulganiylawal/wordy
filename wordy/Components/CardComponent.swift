//
//  CardComponent.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 13/12/2025.
//

import SwiftUI

struct CardComponent<Content: View>: View {
    let title: String
    var content: Content
    @Environment(\.colorScheme) var colorScheme
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .padding()

    }
}

#Preview {
    CardComponent(title: "Hello") {
        VStack {
            Text("Hello World")
        }
    }
}
