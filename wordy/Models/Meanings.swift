

import Foundation
struct Meanings : Codable,Equatable {
	let partOfSpeech : String?
	let definitions : [Definitions]?
	

	enum CodingKeys: String, CodingKey {

		case partOfSpeech = "partOfSpeech"
		case definitions = "definitions"
		
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		partOfSpeech = try values.decodeIfPresent(String.self, forKey: .partOfSpeech)
		definitions = try values.decodeIfPresent([Definitions].self, forKey: .definitions)

	}

}
