//
//  ImageTableViewCell.swift
//  gallery
//
//  Created by Algis on 17/10/2020.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var onReuse: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
        photoImageView.cancelImageLoad()
    }
    
    func setup(title: String) {
        self.recipeNameLabel.text = title
    }
    
}
