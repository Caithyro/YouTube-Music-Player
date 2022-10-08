
import Foundation

struct StatisticsForChannelThumbnails: Codable {
    
	let statisticsForChannelDefault: StatisticsForChannelDefault?
	let statisticsForChannelMedium: StatisticsForChannelMedium?
	let statisticsForChannelHigh: StatisticsForChannelHigh?

	enum CodingKeys: String, CodingKey {

		case statisticsForChannelDefault = "default"
		case statisticsForChannelMedium = "medium"
		case statisticsForChannelHigh = "high"
	}

	init(from decoder: Decoder) throws {
        
		let values = try decoder.container(keyedBy: CodingKeys.self)
        statisticsForChannelDefault = try values.decodeIfPresent(StatisticsForChannelDefault.self, forKey: .statisticsForChannelDefault)
        statisticsForChannelMedium = try values.decodeIfPresent(StatisticsForChannelMedium.self, forKey: .statisticsForChannelMedium)
        statisticsForChannelHigh = try values.decodeIfPresent(StatisticsForChannelHigh.self, forKey: .statisticsForChannelHigh)
	}

}
