//
//  LLMModelView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//

import SwiftUI
import MLXLMCommon

struct LLMModelView: View {
    @Environment(LocalLLmService.self) var localLLM
    @EnvironmentObject var prefrences: UserStores
    @State var showInstallModelView = false
    var body: some View {
        Form {
            Section(header: Text("Installed")) {
                ForEach(prefrences.installedModels, id: \.self) { modelName in
                    Button {
                        Task {
                            await switchModel(modelName)
                        }
                    } label: {
                        Label {
                            Text(prefrences.modelDisplayName(modelName))
                                .tint(.primary)
                        } icon: {
                            Image(systemName: prefrences.currentModelName == modelName ? "checkmark.circle.fill" : "circle")
                        }
                    }
                    .hapticFeedback()
               
                    
                }
            }
            
            Button {
                showInstallModelView.toggle()
            } label: {
                Label("install a model", systemImage: "arrow.down.circle.dotted")
            }
            .hapticFeedback()
            
            
        }
        .formStyle(.grouped)
        .navigationTitle("Models")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func switchModel(_ modelName: String) async {
        if let model = ModelConfiguration.availableModels.first(where: {
            $0.name == modelName
        }) {
            prefrences.currentModelName = modelName
            
            await localLLM.switchModel(model)
        }
    }
}

#Preview {
    LLMModelView()
}
