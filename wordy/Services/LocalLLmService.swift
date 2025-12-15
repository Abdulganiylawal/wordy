//
//  LocalLLmService.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//

import Foundation
import MLX
import MLXLLM
import MLXLMCommon
import SwiftUI
import Hub
internal import Tokenizers


import Foundation


class MLXFolderManager {
    

    private static let appGroupID = "group.com.lawalAbdulganiy.llm.models"
    

    private static let folderName = "MLXModels"
    

    public static var sharedFolderURL: URL {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            fatalError("Failed to access App Group container")
        }
        
        let folderURL = containerURL.appendingPathComponent(folderName)
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                print("Created MLXModels folder at \(folderURL.path)")
            } catch {
                fatalError("Failed to create MLXModels folder: \(error)")
            }
        }
        
        return folderURL
    }
}


@Observable
class LocalLLmService {
    
    @ObservationIgnored var modelConfiguration: ModelConfiguration
    var loading: Loading = .na
    var downloadProgress = 0.0
    var modelContainer: ModelContainer?
    var cancelled = false
    var output = ""
    
    init() {
        self.modelConfiguration = ModelConfiguration.defaultModel
    }
    
    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }
    
    public var defaultHubApi: HubApi = {
        HubApi(downloadBase: MLXFolderManager.sharedFolderURL)
    }()

    let generateParameters = GenerateParameters(
        temperature: 0.25,
        topP: 0.85,
        repetitionPenalty: 1.05,
        //        stopSequences: ["}\n\n", "```"]
    )
    
    let maxTokens = 4096
    
    var loadState = LoadState.idle
    
    func load(modelName: String) async throws -> ModelContainer {
        guard let model = ModelConfiguration.getModelByName(modelName) else {
            throw NSError(domain: "Model not found", code: 404)
        }
        
        switch loadState {
        case .idle:
            //            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
            let modelContainer = try await LLMModelFactory.shared.loadContainer(
                hub: defaultHubApi,
                configuration: model
            ) { [weak self] progress in
                guard let self else { return }
                debugLog(
                    "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                )
                self.downloadProgress = progress.fractionCompleted
            }
            loadState = .loaded(modelContainer)
            return modelContainer
            
        case .loaded(let modelContainer):
            debugLog("Model loaded successfully")
            return modelContainer
        }
    }
    
    func input(word: String) async {
        guard let modelContainer else { return }
        
        do {
            updateLoading(status: .loading)
            let result = try await modelContainer.perform { context in
                
                let prompt = UserInput(prompt: createPrompt(word, images: []))
                
                let input = try await context.processor.prepare(input: prompt)
                return try MLXLMCommon.generate(
                    input: input,
                    parameters: generateParameters,
                    context: context
                ) { tokens in
                    
                    var cancelled = false
                    
                    Task { @MainActor in
                        cancelled = self.cancelled
                    }
                    
                    let text = context.tokenizer.decode(tokens: tokens)
                    Task { @MainActor in
                        self.output = text
                    }
                    
                    if tokens.count >= maxTokens || cancelled {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }
            
            if result.output != output {
                output = result.output
            }
            debugLog("Result is \(output)")
            updateLoading(status: .finished)
        } catch {
            updateLoading(status: .failed)
            debugLog("Error in input: \(error.localizedDescription)")
        }
    }
    
    func switchModel(_ model: ModelConfiguration) async -> (Bool, Error?) {
        downloadProgress = 0.0
        loadState = .idle
        modelConfiguration = model
        do {
            _ = try await load(modelName: model.name)
            return (true, nil)
        } catch {
            debugLog("Error in switchModel: \(error.localizedDescription)")
            return (false, error)
            
        }
    }
    
    private nonisolated func createPrompt(
        _ prompt: String,
        images: [UserInput.Image]
    ) -> UserInput.Prompt {
        if images.isEmpty {
            return .text(
                """
                You are a dictionary assistant.
                
                Define the STANDARD English dictionary meaning of the word "\(prompt)".

                STRICT RULES:
                - The word MUST NOT be used inside its own definition
                - Do NOT invent verb forms if the word is not a verb
                - Use the most common dictionary meaning only
                - If the spelling is incorrect, silently correct it
                - If the word is an adjective, return "adjective" as typeOfWord
                
                Your response MUST be a valid JSON object with EXACTLY the following fields:
                
                - "definition": string
                - "typeOfWord": string (noun, verb, adjective, adverb, etc.)
                - "synonyms": array of strings
                - "antonyms": array of strings
                - "example": array of strings (example sentences)
                
                Additional rules:
                - "typeOfWord" must be one word (noun, verb, adjective, or adverb)
                - No extra fields
                - No markdown
                - No explanations
                - JSON only
                """
            )
            
        } else {
            
            let message: Message = [
                "role": "user",
                "content": [
                    ["type": "text", "text": prompt]
                ] + images.map { _ in ["type": "image"] },
            ]
            
            return .messages([message])
        }
    }
    
    func updateLoading(status: Loading) {
        withAnimation {
            self.loading = status
        }
    }
}

// fixing not downloading models on iphone

//I see how the download directory could potentially be a problem, but that was not the actual problem. I figured that when i changed the data mode in the sim to "Allow More Data on 5G" rather than the usual "Standard", that triggered the download.
//I am not an expert, so am unsure how this can be controlled apart from actually educating the user in an app that would want to download the LLM
