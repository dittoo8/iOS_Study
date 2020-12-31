//
//  MyApiStatusLogger.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/24.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import Foundation
import Alamofire

final class MyApiStatusLogger: EventMonitor {
    let queue = DispatchQueue(label: "MyApiStatusLogger")
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        
        guard let statusCode = request.response?.statusCode else { return }
        
        print("MyApiStatusLogger - statusCode: \(statusCode)")
    }
}
