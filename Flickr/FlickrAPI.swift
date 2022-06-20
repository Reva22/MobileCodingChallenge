//
//  FlickrAPI.swift
//  Flickr
//
//  Created by Reva Tamaskar on 15/06/22.
//

import Foundation
import UIKit

enum EndPoint: String{
    case Photos = "flickr.photos.getRecent"
}

struct FlickrResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    let photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
}

protocol APIProtocol{
    var url : URL { get }
    func photos(fromJSON data: Data) -> Result<[Photo], Error>
}

struct FlickrAPI: APIProtocol {
    var url: URL
    {
        return PhotosURL
    }
    
    let baseURL = "https://api.flickr.com/services/rest"
    let APIKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    var text : String
    init(text : String){
        self.text = text
    }
    
    func flickrURL(endPoint: EndPoint,parameters: [String:String]?) -> URL {
    var components = URLComponents(string: baseURL)!
    var queryItems = [URLQueryItem]()
    
    
    let baseParams = [
        "method" : endPoint.rawValue,
        "api_key" : APIKey,
        "format" : "json",
        "nojsoncallback" : "1",
        "safe_search": "1",
        "text": text
    ]
     
        
    for (key,value) in baseParams{
        let item = URLQueryItem(name: key, value: value)
        queryItems.append(item)
    }
   
    components.queryItems = queryItems
    
    print(components.queryItems!)
    print(text)
    return components.url!
        
    }
    var PhotosURL: URL {
        return flickrURL(endPoint: .Photos,parameters: [:])
    }
    
    func photos(fromJSON data: Data) -> Result<[Photo], Error> {
        do {
            let decoder = JSONDecoder()
            
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            let photos = flickrResponse.photosInfo.photo.filter
            { $0.server != nil && $0.id != nil && $0.secret != nil && $0.farm != nil}
            return .success(photos)
            
            }
      catch {
            return .failure(error)
            }

        }
        
}


