//
//  ImageSearchAPImanager.swift
//  Pagenation
//
//  Created by 김태현 on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class ImageSearchAPIManager {
    
    static let shared = ImageSearchAPIManager()
    
    private init() { }
    
    typealias completionHandler = ([String], Int) -> Void
    
    func fetchImageData(text: String, startPage: Int, completionHandler: @escaping completionHandler) {
        
        guard let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = EndPoint.naverSearchURL + "query=\(query)&start=\(startPage)&display=30"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.NAVER_ID,
            "X-Naver-Client-Secret": APIKey.NAVER_SECRET,
        ]
        
        AF.request(url, method: .get, headers: headers).validate(statusCode:  200...500).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let newDataList = json["items"].arrayValue.map { $0["link"].stringValue }
                
//                self.imageURLList.append(contentsOf: newDataList)
//                self.imageCollectionView.reloadData()
                
                let totalPage = json["total"].intValue
                
                completionHandler(newDataList, totalPage)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
