//
//  ImageSearchCollectionViewCell.swift
//  Pagenation
//
//  Created by 김태현 on 2022/08/07.
//

import UIKit

import Kingfisher

class ImageSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var naverImageView: UIImageView!
    
    func bindingNaverImageView(imgURL: String) {
        
        let url = URL(string: imgURL)
        naverImageView.kf.setImage(with: url)
        
        naverImageView.contentMode = .scaleAspectFill
    }
}
