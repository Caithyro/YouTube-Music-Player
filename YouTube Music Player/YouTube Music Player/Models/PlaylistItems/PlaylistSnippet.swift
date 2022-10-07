
import Foundation

struct PlaylistSnippet: Codable {
    
	let publishedAt: String?
	let channelId: String?
	let title: String?
	let description: String?
	let thumbnails: PlaylistThumbnails?
	let channelTitle: String?
	let playlistId: String?
	let position: Int?
	let resourceId: PlaylistResourceId?
	let videoOwnerChannelTitle: String?
	let videoOwnerChannelId: String?

	enum CodingKeys: String, CodingKey {

		case publishedAt = "publishedAt"
		case channelId = "channelId"
		case title = "title"
		case description = "description"
		case thumbnails = "thumbnails"
		case channelTitle = "channelTitle"
		case playlistId = "playlistId"
		case position = "position"
		case resourceId = "resourceId"
		case videoOwnerChannelTitle = "videoOwnerChannelTitle"
		case videoOwnerChannelId = "videoOwnerChannelId"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
		channelId = try values.decodeIfPresent(String.self, forKey: .channelId)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		thumbnails = try values.decodeIfPresent(PlaylistThumbnails.self, forKey: .thumbnails)
		channelTitle = try values.decodeIfPresent(String.self, forKey: .channelTitle)
		playlistId = try values.decodeIfPresent(String.self, forKey: .playlistId)
		position = try values.decodeIfPresent(Int.self, forKey: .position)
		resourceId = try values.decodeIfPresent(PlaylistResourceId.self, forKey: .resourceId)
		videoOwnerChannelTitle = try values.decodeIfPresent(String.self, forKey: .videoOwnerChannelTitle)
		videoOwnerChannelId = try values.decodeIfPresent(String.self, forKey: .videoOwnerChannelId)
	}

}
