

import Foundation
struct Meanings : Codable {
	let partOfSpeech : String?
	let definitions : [Definitions]?
	let synonyms : [String]?
	let antonyms : [String]?

	enum CodingKeys: String, CodingKey {

		case partOfSpeech = "partOfSpeech"
		case definitions = "definitions"
		case synonyms = "synonyms"
		case antonyms = "antonyms"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		partOfSpeech = try values.decodeIfPresent(String.self, forKey: .partOfSpeech)
		definitions = try values.decodeIfPresent([Definitions].self, forKey: .definitions)
		synonyms = try values.decodeIfPresent([String].self, forKey: .synonyms)
		antonyms = try values.decodeIfPresent([String].self, forKey: .antonyms)
	}

}
