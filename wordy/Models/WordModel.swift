
import Foundation
struct WordModel : Codable {
	let word : String?
	let phonetic : String?
	let phonetics : [Phonetics]?
	let meanings : [Meanings]?
	let license : License?
	let sourceUrls : [String]?

	enum CodingKeys: String, CodingKey {

		case word = "word"
		case phonetic = "phonetic"
		case phonetics = "phonetics"
		case meanings = "meanings"
		case license = "license"
		case sourceUrls = "sourceUrls"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		word = try values.decodeIfPresent(String.self, forKey: .word)
		phonetic = try values.decodeIfPresent(String.self, forKey: .phonetic)
		phonetics = try values.decodeIfPresent([Phonetics].self, forKey: .phonetics)
		meanings = try values.decodeIfPresent([Meanings].self, forKey: .meanings)
		license = try values.decodeIfPresent(License.self, forKey: .license)
		sourceUrls = try values.decodeIfPresent([String].self, forKey: .sourceUrls)
	}

}
