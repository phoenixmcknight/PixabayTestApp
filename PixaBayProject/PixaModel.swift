

import Foundation
import UIKit
// MARK: - Picture
struct Picture: Codable {

    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let largeImageURL: String?
    let id,views, comments: Int?
    let pageURL: String?
    let tags: String?
    let user: String?
    
    static func returnDataAsHitArray(data:Data)throws -> [Hit]? {
        do {
            let pixaBayDataDecoded = try JSONDecoder().decode(Picture.self, from: data)
            return pixaBayDataDecoded.hits
        } catch {
            print(error)
            return nil
        }
    }
    
}

