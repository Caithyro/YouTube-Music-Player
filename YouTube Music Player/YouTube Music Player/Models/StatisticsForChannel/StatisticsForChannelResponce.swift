
import Foundation

struct StatisticsForChannelResponce: Codable {
    
	let kind: String?
	let etag: String?
	let pageInfo: StatisticsForChannelPageInfo?
	let items: [StatisticsForChannelItems]?

	enum CodingKeys: String, CodingKey {

		case kind = "kind"
		case etag = "etag"
		case pageInfo = "pageInfo"
		case items = "items"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		etag = try values.decodeIfPresent(String.self, forKey: .etag)
		pageInfo = try values.decodeIfPresent(StatisticsForChannelPageInfo.self, forKey: .pageInfo)
		items = try values.decodeIfPresent([StatisticsForChannelItems].self, forKey: .items)
	}

}
