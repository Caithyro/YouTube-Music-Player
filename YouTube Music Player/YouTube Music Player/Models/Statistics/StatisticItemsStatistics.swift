
import Foundation

struct StatisticItemsStatistics: Codable {
    
    let viewCount: String?
    let likeCount: String?
    let favoriteCount: String?
    let commentCount: String?
    
    enum CodingKeys: String, CodingKey {
        
        case viewCount = "viewCount"
        case likeCount = "likeCount"
        case favoriteCount = "favoriteCount"
        case commentCount = "commentCount"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        viewCount = try values.decodeIfPresent(String.self, forKey: .viewCount)
        likeCount = try values.decodeIfPresent(String.self, forKey: .likeCount)
        favoriteCount = try values.decodeIfPresent(String.self, forKey: .favoriteCount)
        commentCount = try values.decodeIfPresent(String.self, forKey: .commentCount)
    }
    
}
