
import Foundation

struct PlaylistPageInfo: Codable {
    
    let totalResults: Int?
    let resultsPerPage: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case totalResults = "totalResults"
        case resultsPerPage = "resultsPerPage"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        resultsPerPage = try values.decodeIfPresent(Int.self, forKey: .resultsPerPage)
    }
    
}
