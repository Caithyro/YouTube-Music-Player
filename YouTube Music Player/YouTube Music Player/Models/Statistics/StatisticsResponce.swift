
import Foundation

struct StatisticsResponce: Codable {
    
	let kind: String?
    let etag: String?
	let statisticsItems: [StatisticsItems]?
	let pageInfo: StatisticItemsPageInfo?

	enum CodingKeys: String, CodingKey {

		case kind = "kind"
		case etag = "etag"
		case statisticsItems = "items"
		case pageInfo = "pageInfo"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		etag = try values.decodeIfPresent(String.self, forKey: .etag)
        statisticsItems = try values.decodeIfPresent([StatisticsItems].self, forKey: .statisticsItems)
		pageInfo = try values.decodeIfPresent(StatisticItemsPageInfo.self, forKey: .pageInfo)
	}

}
