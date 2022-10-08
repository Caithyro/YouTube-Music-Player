
import Foundation

struct StatisticsForChannelContentDetails: Codable {
    
	let relatedPlaylists: StatisticsForChannelRelatedPlaylists?

	enum CodingKeys: String, CodingKey {

		case relatedPlaylists = "relatedPlaylists"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		relatedPlaylists = try values.decodeIfPresent(StatisticsForChannelRelatedPlaylists.self, forKey: .relatedPlaylists)
	}

}
