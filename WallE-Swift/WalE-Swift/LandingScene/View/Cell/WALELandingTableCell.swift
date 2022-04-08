//
//  WALELandingTableCell.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import UIKit

final class WALELandingTableCell: UITableViewCell {

    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(withAPOD apod: APOD) {
        labelTitle.text = apod.title
        labelDescription.text = apod.explanation
    }
}
