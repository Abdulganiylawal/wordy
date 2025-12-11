//
//  Settings.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(LocalLLmService.self) var localLLM
    @EnvironmentObject var prefrences: UserStores
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    LLMModelView()
                } label: {
                    Label {
                        Text("Models")
                            .fixedSize()
                    } icon: {
                        Image(systemName: "arrow.down.circle")
                    }
                }
                .badge(prefrences.modelDisplayName(prefrences.currentModelName ?? ""))
                
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
