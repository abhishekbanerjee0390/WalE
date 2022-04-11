//
//  WALELandingImageTableCell.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 11/04/22.
//

import UIKit

class WALELandingImageTableCell: UITableViewCell {

    @IBOutlet private var imageViewAPOD: UIImageView!
    
    func setImage(withImageData imageData: Data) {
        self.imageViewAPOD.image = UIImage(data: imageData)
    }
}
