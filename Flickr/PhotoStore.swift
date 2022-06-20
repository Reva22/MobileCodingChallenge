//
//  PhotoStore.swift
//  Flickr
//
//  Created by Reva Tamaskar on 15/06/22.
//
import UIKit
import Foundation

enum PhotoError : Error {
    case ImageCreationError
    case missingimageURL
}

class PhotoStore {
    private let session : URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchPhotos(api: APIProtocol ,completion: @escaping(Result<[Photo],Error>)-> Void){
        
        let url = api.url
        print(url)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            [weak self](data, response, error) in
            
            let result = self?.processPhotosRequest(data: data,api: api, error: error)
            OperationQueue.main.addOperation {
                completion(result!)
            }
            
        }
        task.resume()
    }
    
    func fetchImages(for photo: Photo ,completion: @escaping(Result<UIImage,Error>)->Void) {
        
        guard let farm = photo.farm , let server = photo.server, let id = photo.id, let secret = photo.secret else { return
        }
        let photoURLstr = "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        
        guard let photoURL = URL(string: photoURLstr) else {
            return }
        
        let request = URLRequest(url: photoURL)
            let task = session.dataTask(with: request) {
                (data, response, error) in
                let result = self.processImageRequest(data: data, error: error)
                OperationQueue.main.addOperation {
                    completion(result)
                }
        }
        task.resume()
        
    }

    private func processPhotosRequest(data: Data?, api : APIProtocol,
                                      error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return api.photos(fromJSON: jsonData)
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            }
            else {
                return .failure(PhotoError.ImageCreationError)
            }
            }
            return .success(image)
            
    }
    

}
