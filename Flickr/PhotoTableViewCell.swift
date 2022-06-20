//
//  PhotoCollectionViewCell.swift
//  Flickr
//
//  Created by Reva Tamaskar on 17/06/22.
//

import Foundation
import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    var imageView2: UIImageView = UIImageView()
    init(reuseIdentifier: String?, image : UIImage?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(imageView2)
        
        update(displaying: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            imageView2.image = imageToDisplay
        } else {
            imageView2.image = nil
        }
    }
    
    //customizing cells
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
