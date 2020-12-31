//
//  Photo.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/31.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var thumbnail: String
    var username: String
    var likesCount: Int
    var createdAt: String
    
}
