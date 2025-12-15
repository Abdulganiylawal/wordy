

import Foundation
struct Phonetics : Codable,Equatable {
	let text : String?
	let audio : String?
	let sourceUrl : String?
	let license : License?

	enum CodingKeys: String, CodingKey {

		case text = "text"
		case audio = "audio"
		case sourceUrl = "sourceUrl"
		case license = "license"
	}

	init(text: String, audio: String, sourceUrl: String? = nil, license: License? = nil) {
		self.text = text
		self.audio = audio
		self.sourceUrl = sourceUrl
		self.license = license
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		audio = try values.decodeIfPresent(String.self, forKey: .audio)
		sourceUrl = try values.decodeIfPresent(String.self, forKey: .sourceUrl)
		license = try values.decodeIfPresent(License.self, forKey: .license)
	}

}
