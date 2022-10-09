
import Foundation

struct StatisticsForChannelRelatedPlaylists: Codable {
    
    let likes: String?
    let uploads: String?
    
    enum CodingKeys: String, CodingKey {
        
        case likes = "likes"
        case uploads = "uploads"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        likes = try values.decodeIfPresent(String.self, forKey: .likes)
        uploads = try values.decodeIfPresent(String.self, forKey: .uploads)
    }
    
}
