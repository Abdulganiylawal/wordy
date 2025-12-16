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
    @State private var showTimePicker: Bool = false
    var body: some View {
        VStack{
            Form {
                Section {
                    NavigationLink {
                        LLMModelView()
                    } label: {
                        Label {
                            Text("Models")
                                .fixedSize()
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "arrow.down.circle")
                        }
                    }
                    .badge(prefrences.modelDisplayName(prefrences.currentModelName ?? ""))
                    
                    NavigationLink {
                        MLXModelsDebugView()
                    } label: {
                        Label {
                            Text("Downloaded Models")
                                .fixedSize()
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "folder.fill")
                        }
                    }
                    
                    Button {
                        withAnimation(Tokens.menuSpring) {
                            showTimePicker = true
                        }
                    } label: {
                        Label {
                            Text("Notification")
                                .fixedSize()
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "bell.fill")
                        }
                    }
                }
                .formStyle(.grouped)
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .overlay(alignment:.bottom) {
            if showTimePicker {
                TimePicker()
                    .transition(.blurReplace.combined(with: .push(from: .bottom)))
                
            }
        }
    }
}

#Preview {
    SettingsView()
}
