
import Foundation

struct PlaylistSnippetThumbnails: Codable {
    
    let defaultThumbnail: PlaylistSnippetDefault?
    let medium: PlaylistSnippetMedium?
    let high: PlaylistSnippetHigh?
    let standard: PlaylistSnippetStandard?
    let maxres: PlaylistSnippetMaxres?
    
    enum CodingKeys: String, CodingKey {
        
        case defaultThumbnail = "default"
        case medium = "medium"
        case high = "high"
        case standard = "standard"
        case maxres = "maxres"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        defaultThumbnail = try values.decodeIfPresent(PlaylistSnippetDefault.self,
                                                      forKey: .defaultThumbnail)
        medium = try values.decodeIfPresent(PlaylistSnippetMedium.self,
                                            forKey: .medium)
        high = try values.decodeIfPresent(PlaylistSnippetHigh.self,
                                          forKey: .high)
        standard = try values.decodeIfPresent(PlaylistSnippetStandard.self,
                                              forKey: .standard)
        maxres = try values.decodeIfPresent(PlaylistSnippetMaxres.self,
                                            forKey: .maxres)
    }
    
}
