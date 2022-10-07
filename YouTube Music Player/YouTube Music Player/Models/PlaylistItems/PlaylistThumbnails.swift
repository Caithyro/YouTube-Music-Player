
import Foundation

struct PlaylistThumbnails: Codable {
    
	let defaultThumbnail: PlaylistDefault?
	let medium: PlaylistMedium?
	let high: PlaylistHigh?
	let standard: PlaylistStandard?
    let maxres: PlaylistMaxres?

	enum CodingKeys: String, CodingKey {

		case defaultThumbnail = "default"
		case medium = "medium"
		case high = "high"
		case standard = "standard"
		case maxres = "maxres"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        defaultThumbnail = try values.decodeIfPresent(PlaylistDefault.self, forKey: .defaultThumbnail)
		medium = try values.decodeIfPresent(PlaylistMedium.self, forKey: .medium)
		high = try values.decodeIfPresent(PlaylistHigh.self, forKey: .high)
		standard = try values.decodeIfPresent(PlaylistStandard.self, forKey: .standard)
		maxres = try values.decodeIfPresent(PlaylistMaxres.self, forKey: .maxres)
	}

}
