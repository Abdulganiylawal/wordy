//
//  WordModel.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//


import Foundation
import GRDB

struct AIDictionaryModel: Codable, Equatable {
    let definition: String
    let typeOfWord: String
    let synonyms: [String]
    let antonyms: [String]
    let example: [String]


    init(definition: String, typeOfWord: String, synonyms: [String], antonyms: [String], example: [String]) {
        self.definition = definition
        self.typeOfWord = typeOfWord
        self.synonyms = synonyms
        self.antonyms = antonyms
        self.example = example
    }

    enum CodingKeys: String, CodingKey {
        case definition = "definition"
        case typeOfWord = "typeOfWord"
        case synonyms = "synonyms"
        case antonyms = "antonyms"
        case example = "example"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        definition = try values.decode(String.self, forKey: .definition)
        typeOfWord = try values.decode(String.self, forKey: .typeOfWord)
        synonyms = try values.decode([String].self, forKey: .synonyms)
        antonyms = try values.decode([String].self, forKey: .antonyms)
        example = try values.decode([String].self, forKey: .example)
    }
}

struct MeaningModel: Codable, Equatable{
    let word: String
    let partOfSpeech: String?
    let phonetics: [Phonetics]?
    let definitions: AIDictionaryModel

    enum CodingKeys: String, CodingKey {
        case word = "word"
        case partOfSpeech = "partOfSpeech"
        case phonetics = "phonetics"
        case definitions = "definitions"
    }
 
    

    init(word: String, partOfSpeech: String?, phonetics: [Phonetics]?, definitions: AIDictionaryModel) {
        self.word = word
        self.partOfSpeech = partOfSpeech
        self.phonetics = phonetics
        self.definitions = definitions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        word = try values.decode(String.self, forKey: .word)
        partOfSpeech = try values.decodeIfPresent(String.self, forKey: .partOfSpeech)
        phonetics = try values.decodeIfPresent([Phonetics].self, forKey: .phonetics)
        definitions = try values.decode(AIDictionaryModel.self, forKey: .definitions)
    }
    
  
    static func toLocalMeaningModel(meaning: MeaningModel) throws -> LocalMeaningModel {
        // Encode phonetics array to JSON string
        let phoneticsString: String
        if let phonetics = meaning.phonetics {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            let phoneticsData = try encoder.encode(phonetics)
            phoneticsString = String(data: phoneticsData, encoding: .utf8) ?? "[]"
        } else {
            phoneticsString = "[]"
        }
        
        // Encode definitions model to JSON string
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let definitionsData = try encoder.encode(meaning.definitions)
        let definitionsString = String(data: definitionsData, encoding: .utf8) ?? "{}"
        
        return LocalMeaningModel(
            id: nil,
            word: meaning.word,
            partOfSpeech: meaning.partOfSpeech ?? "",
            phonetics: phoneticsString,
            definitions: definitionsString
        )
    }
   
}


