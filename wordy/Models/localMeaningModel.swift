


import Foundation
import GRDB

// this is the model for the local database
struct LocalMeaningModel: Codable, Equatable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    let partOfSpeech: String
    let phonetics: String
    let definitions: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case partOfSpeech = "partOfSpeech"
        case phonetics = "phonetics"
        case definitions = "definitions"
    }
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let partOfSpeech = Column(CodingKeys.partOfSpeech)
        static let phonetics = Column(CodingKeys.phonetics)
        static let definitions = Column(CodingKeys.definitions)
    }
    
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }



    static func databaseJSONEncoder(for column: String) -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }
    
    static func databaseJSONDecoder(for column: String) -> JSONDecoder {
        JSONDecoder()
    }
    
   static func toMeaningModel(localMeaning: LocalMeaningModel) throws -> MeaningModel {
       // Decode phonetics JSON string to [Phonetics]?
       let phoneticsArray: [Phonetics]?
       if localMeaning.phonetics.isEmpty {
           phoneticsArray = nil
       } else {
           let phoneticsData = localMeaning.phonetics.data(using: .utf8)!
           phoneticsArray = try? JSONDecoder().decode([Phonetics].self, from: phoneticsData)
       }
       
       // Decode definitions JSON string to AIDictionaryModel
       let definitionsData = localMeaning.definitions.data(using: .utf8)!
       let definitionsModel = try JSONDecoder().decode(AIDictionaryModel.self, from: definitionsData)
       
       return MeaningModel(
           partOfSpeech: localMeaning.partOfSpeech.isEmpty ? nil : localMeaning.partOfSpeech,
           phonetics: phoneticsArray,
           definitions: definitionsModel
       )
   }
}

private typealias MeaningColumns = LocalMeaningModel.Columns

extension LocalMeaningModel : TableRecord {
    static let databaseTableName = "meanings"

}

