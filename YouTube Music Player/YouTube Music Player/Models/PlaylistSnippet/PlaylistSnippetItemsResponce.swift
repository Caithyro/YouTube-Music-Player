
import Foundation

struct PlaylistSnippetItemsResponce: Codable {
    
    let kind: String?
    let etag: String?
    let pageInfo: PlaylistSnippetPageInfo?
    let items: [PlaylistSnippetItems]?
    
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
        pageInfo = try values.decodeIfPresent(PlaylistSnippetPageInfo.self,
                                              forKey: .pageInfo)
        items = try values.decodeIfPresent([PlaylistSnippetItems].self,
                                           forKey: .items)
    }
    
}
