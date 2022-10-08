
import Foundation

struct StatisticsForChannelStatistics: Codable {
    
	let viewCount: String?
	let subscriberCount: String?
	let hiddenSubscriberCount: Bool?
	let videoCount: String?

	enum CodingKeys: String, CodingKey {

		case viewCount = "viewCount"
		case subscriberCount = "subscriberCount"
		case hiddenSubscriberCount = "hiddenSubscriberCount"
		case videoCount = "videoCount"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		viewCount = try values.decodeIfPresent(String.self, forKey: .viewCount)
		subscriberCount = try values.decodeIfPresent(String.self, forKey: .subscriberCount)
		hiddenSubscriberCount = try values.decodeIfPresent(Bool.self, forKey: .hiddenSubscriberCount)
		videoCount = try values.decodeIfPresent(String.self, forKey: .videoCount)
	}

}
