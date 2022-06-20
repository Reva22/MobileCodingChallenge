//
//  ViewController.swift
//  Flickr
//
//  Created by Reva Tamaskar on 14/06/22.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var store = PhotoStore()
    let photodatastore = PhotoDataStore()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
         
        if let searchedText = searchBar.text, searchedText != "" {
            let flickrAPI = FlickrAPI(text: searchedText)
            
            store.fetchPhotos(api: flickrAPI) {
                [weak self](photosResult) in
                switch photosResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) photos.")
                    self?.photodatastore.photos = photos
                case let .failure(error):
                    print("Error fetching interesting photos: \(error)")
                    self?.photodatastore.photos.removeAll()
                }
                self?.tableView.reloadData()
            }
        }
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photo = photodatastore.photos[indexPath.row]
        
        store.fetchImages(for: photo) { [self] (result)->Void in

            guard let photoIndex = photodatastore.photos.firstIndex(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)

            if let cell = tableView.cellForRow(at: photoIndexPath) as? PhotoTableViewCell {
                cell.update(displaying: image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Flickr Search"
        
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        tableView.dataSource = photodatastore
        tableView.delegate = self
        tableView.rowHeight = 300
    }


}
