//
//  PhotoDataStore.swift
//  Flickr
//
//  Created by Reva Tamaskar on 16/06/22.
//

import Foundation
import UIKit

class PhotoDataSource: NSObject, UITableViewDataSource {
    var photos = [Photo]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("photo count is",photos.count)
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = dequeue(from : tableView){ reuseIdentifier in
            return PhotoTableViewCell(reuseIdentifier: reuseIdentifier, image: nil)
        }
        cell.imageView2.sizeToFit()
        return cell
    }
    
    
    private func dequeue<T: PhotoTableViewCell>(from tableView: UITableView, create: (_ reuseIdentifier: String) -> T) -> T {
            let reuseIdentifier = String(describing: type(of: T.self))
            if let dequeued = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
                return dequeued
            } else {
                return create(reuseIdentifier)
            }
        }
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    func clearImageCache() {
        cachedImages.removeAllObjects()
    }

}
