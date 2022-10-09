
import Foundation

struct StatisticsForChannelLocalized: Codable {
    
    let title: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        
        case title = "title"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
    
}
