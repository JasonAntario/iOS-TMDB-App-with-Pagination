//
//  ItemReusableView.swift
//  iOS TMDB App with Pagination
//
//  Created by Dmitry Sankovsky on 6.01.23.
//

import UIKit

class ItemReusableView: UICollectionViewCell {

    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
