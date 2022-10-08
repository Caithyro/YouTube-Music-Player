
import Foundation

struct StatisticsForChannelItems: Codable {
    
	let kind: String?
	let etag: String?
	let id: String?
	let snippet: StatisticsForChannelSnippet?
    let contentDetails : StatisticsForChannelContentDetails?
	let statistics: StatisticsForChannelStatistics?

	enum CodingKeys: String, CodingKey {

		case kind = "kind"
		case etag = "etag"
		case id = "id"
		case snippet = "snippet"
        case contentDetails = "contentDetails"
		case statistics = "statistics"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		etag = try values.decodeIfPresent(String.self, forKey: .etag)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		snippet = try values.decodeIfPresent(StatisticsForChannelSnippet.self, forKey: .snippet)
        contentDetails = try values.decodeIfPresent(StatisticsForChannelContentDetails.self, forKey: .contentDetails)
		statistics = try values.decodeIfPresent(StatisticsForChannelStatistics.self, forKey: .statistics)
	}

}
