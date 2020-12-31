//
//  BaseVC.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/07.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import UIKit
import Toast_Swift
class BaseVC: UIViewController {
    var vcTitle: String = "" {
        didSet {
            print("userListVC - vcTitle didSet cslled : vcTitle : \(vcTitle)")
            self.title = vcTitle + "👩🏻‍💻"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopup(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //인증 실패 노티피케이션 등록 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    //MARK : - objc methods
    @objc func showErrorPopup(notification: NSNotification){
        print("BaseVC - showErrorPopup()")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopup data : \(data)")
            
            // 메인스레드에서 실행
            DispatchQueue.main.async {
                self.view.makeToast("☠️ \(data) 에러입니다.", duration: 1.5, position: .center)
            }
        }
    }
}
