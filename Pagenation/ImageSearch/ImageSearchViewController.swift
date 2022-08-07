//
//  ImageSearchViewController.swift
//  Pagenation
//
//  Created by 김태현 on 2022/08/07.
//

import UIKit

import Alamofire
import SwiftyJSON

class ImageSearchViewController: UIViewController {

    var startPage = 1
    var totalPage = 0
    var imageURLList: [String] = []

    @IBOutlet weak var imageSearchBar: UISearchBar!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSearchBar.delegate = self

        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.prefetchDataSource = self
        imageCollectionView.register(UINib(nibName: ImageSearchCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier)
        
        imageCollectionView.collectionViewLayout = layoutImageCollectionView()
        
        
        requestImageURL(text: "강아지")
    }
    
    @IBAction func tappedScreen(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func layoutImageCollectionView() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        return layout
    }
    

    func requestImageURL(text: String) {
        
        ImageSearchAPIManager.shared.fetchImageData(text: text, startPage: startPage) { newDataList, totalPage in
            
            self.imageURLList.append(contentsOf: newDataList)
            self.totalPage = totalPage
    
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
        
    }

}


extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let text: String
        
        if imageSearchBar.text != "" && imageSearchBar.text != nil {
            text = imageSearchBar.text!
        } else {
            text = "강아지"
        }
        
        for indexPath in indexPaths {
            if imageURLList.count - 1 == indexPath.item && imageURLList.count < totalPage {
                startPage += 30
                requestImageURL(text: text)
                print(text)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print(indexPaths)
    }
}


extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.bindingNaverImageView(imgURL: imageURLList[indexPath.item])
        
        return cell
    }
}


extension ImageSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        imageURLList.removeAll()
//        imageCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//        self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        startPage = 1
        
        guard let text = searchBar.text else { return }
        
        requestImageURL(text: text)
        
        view.endEditing(true)
        imageSearchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        imageSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        imageSearchBar.setShowsCancelButton(false, animated: true)
        
        imageURLList.removeAll()
        startPage = 1
        
        imageSearchBar.text = ""
        
        imageCollectionView.reloadData()
    }
    
}
