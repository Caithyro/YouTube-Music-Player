
import Foundation

struct PlaylistResponce: Codable {
    
    let kind: String?
    let etag: String?
    let nextPageToken: String?
    let playlistItems: [PlaylistItems]?
    let playlistPageInfo: PlaylistPageInfo?
    
    enum CodingKeys: String, CodingKey {
        
        case kind = "kind"
        case etag = "etag"
        case nextPageToken = "nextPageToken"
        case playlistItems = "items"
        case playlistPageInfo = "pageInfo"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        etag = try values.decodeIfPresent(String.self, forKey: .etag)
        nextPageToken = try values.decodeIfPresent(String.self,
                                                   forKey: .nextPageToken)
        playlistItems = try values.decodeIfPresent([PlaylistItems].self,
                                                   forKey: .playlistItems)
        playlistPageInfo = try values.decodeIfPresent(PlaylistPageInfo.self,
                                                      forKey: .playlistPageInfo)
    }
    
}
