//
//  WALELandingImageTableCell.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 11/04/22.
//

import UIKit

final class WALELandingImageTableCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet private(set) var collectionViewImage: UICollectionView! {
        didSet { setupCollectionView() }
    }
    private var imageData: Data? = nil

    func setImage(withImageData imageData: Data) {
        self.imageData = imageData
        collectionViewImage.reloadData()
    }
}

// MARK - UICollectionViewDataSource -
extension WALELandingImageTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageData == nil) ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WALELandingCollectionViewCell", for: indexPath) as! WALELandingCollectionViewCell
        cell.setImage(withImageData: imageData!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK - Private -
private extension WALELandingImageTableCell {
    func setupCollectionView() {
        collectionViewImage.dataSource = self
        collectionViewImage.delegate = self
        let nib = UINib(nibName: "WALELandingCollectionViewCell", bundle: nil)
        collectionViewImage.register(nib, forCellWithReuseIdentifier: "WALELandingCollectionViewCell")
        if let collectionViewLayout = collectionViewImage.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}
