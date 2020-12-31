//
//  MyLogger.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/24.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {
    let queue = DispatchQueue(label: "ApiLog")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume()")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request.didParseResponse()")
        debugPrint(response)
    }
}
