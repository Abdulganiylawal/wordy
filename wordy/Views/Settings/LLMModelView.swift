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
    @State var selectedModel = ModelConfiguration.defaultModel
    @State private var deviceSupportsMetal3: Bool = true
    let suggestedModel = ModelConfiguration.defaultModel
    @State private var wantsToInstallModel = false
    @State var didSwitchModel = false
    @State var error: Error?
    
    func sizeBadge(_ model: ModelConfiguration?) -> String? {
        guard let size = model?.modelSize else { return nil }
        return "\(size) GB"
    }
    
    var installed: Bool {
        localLLM.downloadProgress == 1 && didSwitchModel
    }
    
    let modelMemoryThreshold = 0.6
    
    var canUserInstallModel: Bool {
        return filteredModels.count > 0 && !prefrences.installedModels.contains(selectedModel.name)
    }
    
    var body: some View {
        Group {
            if wantsToInstallModel {
                VStack {
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text(installed ? "Installed" : error != nil ? "Error Installing" : "Installing")
                            .font(.title)
                            .fontWeight(.semibold)
                        Text(error != nil ? error?.localizedDescription ?? "Unknown error" : prefrences.modelDisplayName(selectedModel.name))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    if error == nil {   
                        ProgressView(value: localLLM.downloadProgress, total: 1)
                            .progressViewStyle(.linear)
                            .padding(.horizontal, 48)
                    }
                    
                    Spacer()
                    
                    Text("keep this screen open and wait for the installation to complete.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .transition(.blurReplace)
            }
            else {
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
                            
                            
                            
                        }
                    }

                    if error != nil {
                        Section(header: Text("Error")) {
                            Text(error?.localizedDescription ?? "Unknown error")
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    
                    Section(header: Text("Not Installed")) {
                        ForEach(filteredModels, id: \.name) { model in
                            
                            Button { selectedModel = model }
                            label: {
                                Label {
                                    Text(prefrences.modelDisplayName(model.name))
                                        .tint(.primary)
                                } icon: {
                                    Image(systemName: selectedModel.name == model.name ? "checkmark.circle.fill" : "circle")
                                }
                            }
                            .badge(sizeBadge(model))
                            
                            
                        }
                    }
                    
                    if canUserInstallModel {
                        Button {
                            withAnimation {
                                wantsToInstallModel = true
                            }
                            Task {
                                await loadLLM()
                            }
                        } label: {
                            Label("Install", systemImage: "arrow.down.circle.dotted")
                        }
                        .hapticFeedback(style: .soft)
                        .transition(.blurReplace)
                    }
                }
                .formStyle(.grouped)
                .transition(.blurReplace)
                
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .navigationTitle("Models")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkModels()
        }
        .onChange(of: installed) { oldValue, newValue in
            if newValue {
                addInstalledModel()
            }
        }
    }
    
    
    private func switchModel(_ modelName: String) async {
        if let model = ModelConfiguration.availableModels.first(where: {
            $0.name == modelName
        }) {
            prefrences.currentModelName = modelName
            
            let (success, error) = await localLLM.switchModel(model)
            if success {
                self.error = nil
            } else {
                self.error = error
                debugLog("Error in switchModel: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    
    var filteredModels: [ModelConfiguration] {
        ModelConfiguration.availableModels
            .filter { !prefrences.installedModels.contains($0.name) }
        //            .filter { model in
        //                !(prefrences.installedModels.isEmpty && model.name == suggestedModel.name)
        //            }
            .filter { model in
                guard let size = model.modelSize else { return false }
                return size <= Decimal(modelMemoryThreshold * prefrences.availableMemory)
            }
            .sorted { $0.name < $1.name }
    }
    
    func checkModels() {
        
        if prefrences.installedModels.contains(suggestedModel.name) {
            if let model = filteredModels.first {
                selectedModel = model
            }
        }
    }
    
    
    func loadLLM() async {
        let (success, error) = await localLLM.switchModel(selectedModel)
        if success {
            didSwitchModel = true
            self.error = nil
        } else {
            debugLog("Error in loadLLM: \(error?.localizedDescription ?? "Unknown error")")
            self.error = error
        }
    }
    
    
    func addInstalledModel() {
        if installed {
            debugLog("added installed model")
            prefrences.currentModelName = selectedModel.name
            prefrences.addInstalledModel(selectedModel.name)
        }
    }
}

#Preview {
    LLMModelView()
}
