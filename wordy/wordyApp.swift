//
//  wordyApp.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import SwiftUI

@main
struct wordyApp: App {
    @State var keyboardManager = KeyboardManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(KeyboardManager())
        }
    }
}
