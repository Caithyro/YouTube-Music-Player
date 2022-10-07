
import Foundation

struct PlaylistSnippetSnippet: Codable {
    
	let publishedAt: String?
	let channelId: String?
	let title: String?
	let description: String?
	let thumbnails: PlaylistSnippetThumbnails?
	let channelTitle: String?
	let localized: PlaylistSnippetLocalized?

	enum CodingKeys: String, CodingKey {

		case publishedAt = "publishedAt"
		case channelId = "channelId"
		case title = "title"
		case description = "description"
		case thumbnails = "thumbnails"
		case channelTitle = "channelTitle"
		case localized = "localized"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
		channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		thumbnails = try values.decodeIfPresent(PlaylistSnippetThumbnails.self, forKey: .thumbnails)
		channelTitle = try values.decodeIfPresent(String.self, forKey: .channelTitle)
		localized = try values.decodeIfPresent(PlaylistSnippetLocalized.self, forKey: .localized)
	}

}
