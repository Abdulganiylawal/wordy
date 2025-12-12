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
        case .deepseek_r1_distill_qwen_1_5b_4bit: .reasoning
        case .deepseek_r1_distill_qwen_1_5b_8bit: .reasoning
        case .qwen_3_4b_4bit: .reasoning
        case .qwen_3_8b_4bit: .reasoning
        default: .regular
        }
    }
}

extension ModelConfiguration: @retroactive Equatable {
    public static func == (lhs: MLXLMCommon.ModelConfiguration, rhs: MLXLMCommon.ModelConfiguration) -> Bool {
        return lhs.name == rhs.name
    }

    public static let llama_3_2_1b_4bit:ModelConfiguration = LLMRegistry.llama3_2_1B_4bit

    public static let llama_3_2_3b_4bit = LLMRegistry.llama3_2_3B_4bit

    public static let deepseek_r1_distill_qwen_1_5b_4bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-1.5B-4bit"
    )

    public static let deepseek_r1_distill_qwen_1_5b_8bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-1.5B-8bit"
    )

    public static let qwen_3_4b_4bit = ModelConfiguration(
        id: "mlx-community/Qwen3-4B-4bit"
    )

    public static let qwen_3_8b_4bit = ModelConfiguration(
        id: "mlx-community/Qwen3-8B-4bit"
    )

    public static var availableModels: [ModelConfiguration] = [
        llama_3_2_1b_4bit,
        llama_3_2_3b_4bit,
        deepseek_r1_distill_qwen_1_5b_4bit,
        deepseek_r1_distill_qwen_1_5b_8bit,
        qwen_3_4b_4bit,
        qwen_3_8b_4bit,
    ]

    public static var defaultModel: ModelConfiguration {
        llama_3_2_1b_4bit
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
        case .llama_3_2_1b_4bit: return 0.7
        case .llama_3_2_3b_4bit: return 1.8
        case .deepseek_r1_distill_qwen_1_5b_4bit: return 1.0
        case .deepseek_r1_distill_qwen_1_5b_8bit: return 1.9
        case .qwen_3_4b_4bit: return 2.3
        case .qwen_3_8b_4bit: return 4.7
        default: return nil
        }
    }
}
