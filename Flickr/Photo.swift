//
//  Photo.swift
//  Flickr
//
//  Created by Reva Tamaskar on 15/06/22.
//

import Foundation
class Photo: Codable {
    let farm : Int?
    let server : String?
    let id : String?
    let secret : String?
    
    enum CodingKeys: String, CodingKey {
        case farm
        case server
        case id
        case secret
    }
}
extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}
