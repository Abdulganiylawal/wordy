//
//  wordyApp.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import SwiftUI
import AIProxy

@main
struct wordyApp: App {
    @State var keyboardManager = KeyboardManager()
    init() {
        AIProxy.configure(
            logLevel: .debug,
            printRequestBodies: false,  // Flip to true for library development
            printResponseBodies: false, // Flip to true for library development
            resolveDNSOverTLS: true,
            useStableID: false,         // Please see the docstring if you'd like to enable this
        )
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(KeyboardManager())
        }
    }
}
