
import Foundation

struct PlaylistItems: Codable {
    
    let kind: String?
    let etag: String?
    let id: String?
    let snippet: PlaylistSnippet?
    
    enum CodingKeys: String, CodingKey {
        
        case kind = "kind"
        case etag = "etag"
        case id = "id"
        case snippet = "snippet"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        etag = try values.decodeIfPresent(String.self, forKey: .etag)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        snippet = try values.decodeIfPresent(PlaylistSnippet.self,
                                             forKey: .snippet)
    }
    
}
