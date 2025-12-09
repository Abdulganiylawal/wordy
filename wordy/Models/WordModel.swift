//
//  WordModel.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 09/12/2025.
//




import Foundation

struct AIDictionaryModel: Codable, Equatable {
    let definition: String
    let synonyms: [String]
    let antonyms: [String]
    let example: [String]

    enum CodingKeys: String, CodingKey {
        case definition = "definition"
        case synonyms = "synonyms"
        case antonyms = "antonyms"
        case example = "example"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        definition = try values.decode(String.self, forKey: .definition)
        synonyms = try values.decode([String].self, forKey: .synonyms)
        antonyms = try values.decode([String].self, forKey: .antonyms)
        example = try values.decode([String].self, forKey: .example)
    }
}

struct MeaningModel: Codable, Equatable {
    let partOfSpeech: String?
    let phonetics: [Phonetics]?
    let definitions: AIDictionaryModel

    enum CodingKeys: String, CodingKey {
        case partOfSpeech = "partOfSpeech"
        case phonetics = "phonetics"
        case definitions = "definitions"
    }

    init(partOfSpeech: String?, phonetics: [Phonetics]?, definitions: AIDictionaryModel) {
        self.partOfSpeech = partOfSpeech
        self.phonetics = phonetics
        self.definitions = definitions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        partOfSpeech = try values.decodeIfPresent(String.self, forKey: .partOfSpeech)
        phonetics = try values.decodeIfPresent([Phonetics].self, forKey: .phonetics)
        definitions = try values.decode(AIDictionaryModel.self, forKey: .definitions)
    }
}
