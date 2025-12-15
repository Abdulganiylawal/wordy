//
//  MLXModelsDebugView.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//

import SwiftUI
import MLXLMCommon

struct MLXModelsDebugView: View {
    
    struct ModelFile: Identifiable {
        let id = UUID()
        let name: String
        let sizeInMB: Double
        let url: URL
    }
    
    @State private var modelFiles: [ModelFile] = []
    @EnvironmentObject var preferences: UserStores
    
    var body: some View {
        NavigationView {
            List {
                ForEach(modelFiles) { file in
                    HStack {
                        Text(file.name)
                            .lineLimit(1)
                        Spacer()
                        Text(String(format: "%.2f MB", file.sizeInMB))
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteModelFiles)
            }
            .navigationTitle("MLX Models")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Refresh") {
                loadModelFiles()
            })
            .onAppear {
                loadModelFiles()
            }
        }
    }
    
    /// Loads the model filenames and sizes from the shared MLX folder
    private func loadModelFiles() {
        let folderURL = MLXFolderManager.sharedFolderURL
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: folderURL.path)
            
            modelFiles = fileNames.compactMap { name in
                let fileURL = folderURL.appendingPathComponent(name)
                if let fileSize = try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? UInt64 {
                    return ModelFile(name: name, sizeInMB: Double(fileSize) / 1_048_576, url: fileURL)
                }
                return nil
            }.sorted { $0.name < $1.name }
            
        } catch {
            print("Error reading MLXModels folder: \(error)")
            modelFiles = []
        }
    }
    
    
    private func deleteModelFiles(at offsets: IndexSet) {
        for index in offsets {
            let file = modelFiles[index]
            do {
                try FileManager.default.removeItem(at: file.url)
                print("Deleted \(file.name)")
                
                // Remove from installedModels if it exists
                removeModelFromInstalledList(fileName: file.name)
            } catch {
                print("Failed to delete \(file.name): \(error)")
            }
        }
        modelFiles.remove(atOffsets: offsets)
    }
    
    /// Removes the model from installedModels list by matching the file/folder name to model names
    private func removeModelFromInstalledList(fileName: String) {
        // Try to find matching model name in installedModels
        // Models are stored with names like "mlx-community/Llama-3.2-3B-Instruct-4bit"
        // Files might be stored as folders or files with similar names
        
        // Check if any installed model name contains the file name or vice versa
        for modelName in preferences.installedModels {
            // Direct match (file name matches model name exactly)
            if modelName == fileName {
                preferences.removeInstalledModel(modelName)
                return
            }
            
            // Check if model name ends with the file name (e.g., "mlx-community/FileName" -> "FileName")
            if modelName.hasSuffix("/\(fileName)") || modelName.hasSuffix("\\\(fileName)") {
                preferences.removeInstalledModel(modelName)
                return
            }
            
            // Check if file name matches the model ID part (after mlx-community/)
            if let modelIDRange = modelName.range(of: "mlx-community/") {
                let modelID = String(modelName[modelIDRange.upperBound...])
                if modelID == fileName || fileName.contains(modelID) || modelID.contains(fileName) {
                    preferences.removeInstalledModel(modelName)
                    return
                }
            }
        }
        
        // Also check against all available models to find the correct name
        for model in ModelConfiguration.availableModels {
            if preferences.installedModels.contains(model.name) {
                // Check if the file/folder name matches the model
                if model.name == fileName || 
                   model.name.contains(fileName) || 
                   fileName.contains(model.name.replacingOccurrences(of: "mlx-community/", with: "")) {
                    preferences.removeInstalledModel(model.name)
                    return
                }
            }
        }
    }
}

struct MLXModelsDebugView_Previews: PreviewProvider {
    static var previews: some View {
        MLXModelsDebugView()
    }
}
