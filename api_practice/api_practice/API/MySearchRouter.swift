//
//  MySearchRouter.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/24.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import Foundation
import Alamofire

// 검색관련 api 호출
enum MySearchRouter: URLRequestConvertible {
    
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .searchPhotos, .searchUsers:
            return .get
        }
//        switch self {
//        case .searchPhotos:
//            return .get
//        case .searchUsers:
//            return .post
//        }
    }
    
    //path -> endPoint 로 수정함
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters: [String:String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query": term]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("MySearchRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}
