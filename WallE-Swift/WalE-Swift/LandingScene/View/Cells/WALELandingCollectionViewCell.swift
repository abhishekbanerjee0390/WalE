//
//  WALELandingCollectionViewCell.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 13/04/22.
//

import UIKit

class WALELandingCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageViewAPOD: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setImage(withImageData imageData: Data) {
        self.imageViewAPOD.image = UIImage(data: imageData)
    }
}
