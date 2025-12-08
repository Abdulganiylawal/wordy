

import Foundation
struct Definitions : Codable {
	let definition : String?
	let synonyms : [String]?
	let antonyms : [String]?
	let example : String?

	enum CodingKeys: String, CodingKey {

		case definition = "definition"
		case synonyms = "synonyms"
		case antonyms = "antonyms"
		case example = "example"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		definition = try values.decodeIfPresent(String.self, forKey: .definition)
		synonyms = try values.decodeIfPresent([String].self, forKey: .synonyms)
		antonyms = try values.decodeIfPresent([String].self, forKey: .antonyms)
		example = try values.decodeIfPresent(String.self, forKey: .example)
	}

}
