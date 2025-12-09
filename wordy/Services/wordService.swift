//
//  wordService.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import AIProxy
import Foundation

struct DictionaryEntry: Decodable {
    let word: String
}

class WordService {
    
    let openAIService: OpenAIService
    
    init() {
        openAIService = AIProxy.openAIService(
            partialKey: "v2|9451600a|fzgFdNMrWfvesQzD",
            serviceURL: "https://api.aiproxy.com/ae48d3c5/1e46e778"
        )
    }
    
    /// Decodes a JSON string to the specified Codable type
    /// - Parameters:
    ///   - jsonString: The JSON string to decode
    ///   - type: The type to decode to (must conform to Decodable)
    /// - Returns: The decoded model of the specified type
    /// - Throws: NSError if the JSON string cannot be converted to Data or decoded
    func decodeJSON<T: Decodable>(_ jsonString: String, to type: T.Type) throws -> T {
        // Convert the JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(
                domain: "Invalid response",
                code: 100,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to convert response to data"
                ]
            )
        }
        
        // Decode the JSON to the specified type
        return try JSONDecoder().decode(type, from: jsonData)
    }
    
    private func getWordsFromDictionary(_ word: String) async throws -> (
        [DictionaryModel]
    ) {
        let urlString =
        "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 100)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                let wordModel = try JSONDecoder().decodeLoggingErrors(
                    [DictionaryModel].self,
                    from: data
                )
                return wordModel
            } else {
                throw NSError(domain: "Invalid response", code: response.statusCode)
            }
        }
        return []
        
    }
    
    private func getWordMeaningFromAi(_word: String) async throws -> AIDictionaryModel {
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
                "definition": [
                    "type": "string",
                    "description": "A clear definition of the word.",
                ],
                "typeOfWord": [
                    "type": "string",
                    "description": "The type of word (noun, verb, adjective, adverb, etc.).",
                ],
                "synonyms": [
                    "type": "array",
                    "items": [
                        "type": "string"
                    ],
                    "description": "A list of synonyms for the word.",
                ],
                "antonyms": [
                    "type": "array",
                    "items": [
                        "type": "string"
                    ],
                    "description": "A list of antonyms for the word.",
                ],
                "example": [
                    "type": "array",
                    "items": [
                        "type": "string"
                    ],
                    "description":
                        "A list of example sentences showing how the word is used.",
                ],
            ],
            "required": ["definition", "synonyms", "antonyms", "example", "typeOfWord"],
            "additionalProperties": false,
        ]
        
        do {
            let requestBody = OpenAIChatCompletionRequestBody(
                model: "gpt-5-nano",
                messages: [
                    .system(
                        content: .text(
                            "Return valid JSON only, and follow the specified JSON structure"
                        )
                    ),
                    .user(
                        content: .text(
                            "Return the meaning of the word: \(_word)"
                        )
                    ),
                ],
                responseFormat: .jsonSchema(
                    name: "word_meaning",
                    description: "A dictionary of the word meaning",
                    schema: schema,
                    strict: true
                )
            )
            let response = try await openAIService.chatCompletionRequest(
                body: requestBody,
                secondsToWait: 500
            )
            guard let jsonString = response.choices.first?.message.content else {
                throw NSError(
                    domain: "Invalid response",
                    code: 100,
                    userInfo: [
                        NSLocalizedDescriptionKey: "No content in response"
                    ]
                )
            }
            
//            debugLog("Raw response: \(jsonString)")
            
            
            let dictionaryModel = try decodeJSON(jsonString, to: AIDictionaryModel.self)
            
            return dictionaryModel
        } catch AIProxyError.unsuccessfulRequest(
            let statusCode,
            let responseBody
        ) {
            debugLog(
                "Received \(statusCode) status code with response body: \(responseBody)"
            )
            throw NSError(domain: "Invalid response", code: statusCode)
        } catch {
            debugLog(
                "Could not create OpenAI chat completion with structured outputs: \(error.localizedDescription)"
            )
            throw NSError(
                domain: "Invalid response",
                code: 100,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Failed to process data. Please try again."
                ]
            )
        }
    }
    
    
    func getMeaning(_ words: String) async throws -> (
        [DictionaryModel],
        AIDictionaryModel
    ) {
       async let firstResult =  getWordsFromDictionary(words)
       async let secondResault =  getWordMeaningFromAi(_word: words)
       return try await (firstResult, secondResault)
    }
}
