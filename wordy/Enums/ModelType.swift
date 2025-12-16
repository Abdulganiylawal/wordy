//
//  ModelType.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 11/12/2025.
//


import Foundation
import MLXLMCommon
import MLXLLM

public extension ModelConfiguration {
    enum ModelType {
        case regular, reasoning
    }
    
    var modelType: ModelType {
        switch self {
        case .qwen_3_4b_4bit: .reasoning
     
        default: .regular
        }
    }
}

extension ModelConfiguration: @retroactive Equatable {
    public static func == (lhs: MLXLMCommon.ModelConfiguration, rhs: MLXLMCommon.ModelConfiguration) -> Bool {
        return lhs.name == rhs.name
    }
    
    public static let llama_3_2_3b_4bit = LLMRegistry.llama3_2_3B_4bit
    
    public static let qwen_3_4b_4bit = LLMRegistry.qwen3_4b_4bit
    
    public static let gemma3n_E4B_it_lm_4bit = LLMRegistry.gemma3n_E4B_it_lm_4bit
    
    public static let gemma3n_E2B_it_lm_4bit = LLMRegistry.gemma3n_E2B_it_lm_4bit
    
 
    public static let phi_3_5_mini_instruct_4bit = LLMRegistry.phi3_5_4bit
    
    
    
    public static var availableModels: [ModelConfiguration] = [
        llama_3_2_3b_4bit,
        qwen_3_4b_4bit,
        phi_3_5_mini_instruct_4bit,
        gemma3n_E2B_it_lm_4bit,
        gemma3n_E4B_it_lm_4bit
        
    ]
    
    public static var defaultModel: ModelConfiguration {
        llama_3_2_3b_4bit
    }
    
    public static func getModelByName(_ name: String) -> ModelConfiguration? {
        if let model = availableModels.first(where: { $0.name == name }) {
            return model
        } else {
            return nil
        }
    }
    
    
    /// Returns the model's approximate size, in GB.
    public var modelSize: Decimal? {
        switch self {
        case .llama_3_2_3b_4bit: return 1.8
        case .qwen_3_4b_4bit: return 2.3
            
            // iPhone 14 Pro optimized models
        case .phi_3_5_mini_instruct_4bit: return 2.5
        
        case .gemma3n_E2B_it_lm_4bit: return 2.6
        
        case .gemma3n_E4B_it_lm_4bit: return 3
            
        default: return nil
        }
    }
}
