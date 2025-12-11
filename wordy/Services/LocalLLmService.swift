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

@Observable
class LocalLLmService {
    
    @ObservationIgnored var modelConfiguration: ModelConfiguration
    
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
            
            let modelContainer = try await LLMModelFactory.shared.loadContainer(
                configuration: model
            ) { [unowned self] progress in
                debugLog(
                    "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                )
                self.downloadProgress = progress.fractionCompleted
            }
            loadState = .loaded(modelContainer)
            return modelContainer
            
        case .loaded(let modelContainer):
            return modelContainer
        }
    }
    
    func input(word: String) async{
        guard let modelContainer else { return }
        do {
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
            
        } catch {
            debugLog("Error in input: \(error.localizedDescription)")
        }
    }
    
    
    func switchModel(_ model: ModelConfiguration) async {
        downloadProgress = 0.0
        loadState = .idle
        modelConfiguration = model
        _ = try? await load(modelName: model.name)
    }
    
    
}
