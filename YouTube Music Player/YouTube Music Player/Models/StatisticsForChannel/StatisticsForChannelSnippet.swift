
import Foundation

struct StatisticsForChannelSnippet: Codable {
    
	let title: String?
	let description: String?
	let customUrl: String?
	let publishedAt: String?
	let thumbnails: StatisticsForChannelThumbnails?
	let localized: StatisticsForChannelLocalized?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case description = "description"
		case customUrl = "customUrl"
		case publishedAt = "publishedAt"
		case thumbnails = "thumbnails"
		case localized = "localized"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		customUrl = try values.decodeIfPresent(String.self, forKey: .customUrl)
		publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
		thumbnails = try values.decodeIfPresent(StatisticsForChannelThumbnails.self, forKey: .thumbnails)
		localized = try values.decodeIfPresent(StatisticsForChannelLocalized.self, forKey: .localized)
	}

}
