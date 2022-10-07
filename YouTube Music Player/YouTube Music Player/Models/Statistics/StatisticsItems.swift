
import Foundation

struct StatisticsItems: Codable {
    
	let kind: String?
	let etag: String?
	let id: String?
	let statistics: StatisticItemsStatistics?

	enum CodingKeys: String, CodingKey {

		case kind = "kind"
		case etag = "etag"
		case id = "id"
		case statistics = "statistics"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		etag = try values.decodeIfPresent(String.self, forKey: .etag)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		statistics = try values.decodeIfPresent(StatisticItemsStatistics.self, forKey: .statistics)
	}

}
