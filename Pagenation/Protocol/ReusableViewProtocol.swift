//
//  ReusableViewProtocol.swift
//  Pagenation
//
//  Created by 김태현 on 2022/08/07.
//

import UIKit

protocol ReusableProtocol {
    
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableProtocol {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
