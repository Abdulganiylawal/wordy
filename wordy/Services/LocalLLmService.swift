//
//  LocalLLmService.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//

import Foundation
import MLXLLM
import MLXLMCommon
internal import Tokenizers
import SwiftUI
import MLX

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
    
    let generateParameters = GenerateParameters(temperature: 0.5)
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
    
    func input(word: String) async{
        guard let modelContainer else { return }

        do {
            updateLoading(status: .loading)
            let result = try await modelContainer.perform { context in
                let prompt = UserInput(
                    prompt: "Return the meaning of the word: \(word)"
                )
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
            _  = try await load(modelName: model.name)
            return (true, nil)  
        } catch {
            debugLog("Error in switchModel: \(error.localizedDescription)")
            return (false, error)
           
        }
    }
    
    
    
    private nonisolated func createPrompt(_ prompt: String, images: [UserInput.Image]) -> UserInput.Prompt {
            if images.isEmpty {
                let message: Message = [
                    "role": "system",
                    "content": [
                        [
                            "type": "text",
                            "text": "Return valid JSON only, following the specified JSON schema. Define the following word: \(prompt)"
                        ],
                        [
                            "type": "json_schema",
                            "schema": [
                                "type": "object",
                                "properties": [
                                    "definition": [
                                        "type": "string",
                                        "description": "A clear definition of the word."
                                    ],
                                    "typeOfWord": [
                                        "type": "string",
                                        "description": "The type of word (noun, verb, adjective, adverb, etc.)."
                                    ],
                                    "synonyms": [
                                        "type": "array",
                                        "items": ["type": "string"],
                                        "description": "A list of synonyms for the word."
                                    ],
                                    "antonyms": [
                                        "type": "array",
                                        "items": ["type": "string"],
                                        "description": "A list of antonyms for the word."
                                    ],
                                    "example": [
                                        "type": "array",
                                        "items": ["type": "string"],
                                        "description": "A list of example sentences showing how the word is used."
                                    ]
                                ],
                                "required": ["definition", "synonyms", "antonyms", "example", "typeOfWord"],
                                "additionalProperties": false
                            ]
                        ]
                    ]
                ]
                return .messages([message])
            } else {
             
                let message: Message = [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": prompt]
                    ] + images.map { _ in ["type": "image"] }
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
