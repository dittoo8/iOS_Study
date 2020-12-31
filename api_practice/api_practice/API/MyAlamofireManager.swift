//
//  MyAlamofireManager.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/24.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MyAlamofireManager {
    // 싱글턴 적용
    static let shared = MyAlamofireManager()
    //인터셉터
    let interceptors = Interceptor(adapters: [BaseInterceptor()])
    
    //로거 설정
    let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]
    
    //세션 설정
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], MyError>) -> Void){
        print("MyAlamofireManager - getPhotos() called : \(userInput)")
        self.session
            .request(MySearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                
                let  responseJson = JSON(responseValue)
                
                let jsonArray = responseJson["results"]
                var photos = [Photo]()
                
                print("jsonArray.size : \(jsonArray.count)")
                
                for  (index, subJson): (String, JSON) in jsonArray {
                    print("index: \(index), subJson: \(subJson)")
                    
                    //data parsing
                    let thumbnail = subJson["urls"]["thumb"].string ?? ""
                    let username = subJson["user"]["username"].string ?? ""
                    let likesCount = subJson["likes"].intValue
                    let createdAt = subJson["created_at"].string ?? ""
                    
                    let photoItem = Photo(thumbnail: thumbnail, username: username, likesCount: likesCount, createdAt: createdAt)
                    
                    photos.append(photoItem)
                    
                }
                
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
        })
    }
    
}
