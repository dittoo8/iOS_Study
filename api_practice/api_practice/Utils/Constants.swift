//
//  Constants.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/07.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import Foundation

enum SEGUE_ID {
    static let USER_LIST_VC = "goToUserListVC"
    static let PHOTO_COLLECTION_VC = "goToPhotoCollectionVC"
}

enum API {
    static let BASE_URL: String = "https://api.unsplash.com/"
    static let CLIENT_ID: String = ""
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
