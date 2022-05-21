//
//  MovieTableViewCell.swift
//  PhotosChallenge
//
//  Created by kholy on 18/05/2022.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(photo : Photo){
        self.lblTitle.text = photo.title
        let url = URL(string: "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg")
        self.img.kf.setImage(with: url,placeholder: UIImage(named: "movie-clapper-open"),options: nil)
    }
    
}
