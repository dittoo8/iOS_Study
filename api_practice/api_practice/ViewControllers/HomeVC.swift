//
//  ViewController.swift
//  api_practice
//
//  Created by 박소현 on 2020/12/02.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicater: UIActivityIndicatorView!
    var keyboardDismissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    //MARK: -override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.config()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder() // 포커싱주기
    }
    // 화면이 넘어가기 전에 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVc = prepare()called / segue.identifier \(segue.identifier)")
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다
            let nextVC = segue.destination as! UserListVC
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + "👩🏻‍💻"
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + "🏞"
        default:
            print("default")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - fileprivate methods
    fileprivate func config(){
        // ui 설정
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        self.keyboardDismissTapGesture.delegate = self
        // 제스처 추가하기
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    fileprivate func pushVC(){
        var segueId: String = ""
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = "goToPhotoCollectionVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "goToUserListVC"
        default:
            print("사진 화면으로 이동")
            segueId = "goToPhotoCollectionVC"
        }
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillShowHandle() called")
        //키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if(keyboardSize.height < searchButton.frame.origin.y){
                print("키보드가 버튼을 덮었다")
                let distance = keyboardSize.height - searchButton.frame.origin.y
                self.view.frame.origin.y = distance + searchButton.frame.height
            }
        }
    }
    
    @objc func keyboardWillHideHandle(){
        print("HomeVC - keyboardWillHideHandle")
        self.view.frame.origin.y = 0
    }
    
    //MARK: -IBAction methods
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        pushVC()
        
        guard let userInput = self.searchBar.text else { return }

        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            MyAlamofireManager
                .shared
                .getPhotos(searchTerm: userInput,
                           completion: { [weak self] result in
                guard let self = self else { return }
                                                    
                switch result {
                case .success(let fetchedPhotos):
                    print("HomeVC - getPhotos.success - fetchedPhotos.count : \(fetchedPhotos.count)")
                case .failure(let error):
                    self.view.makeToast("\(error.rawValue)", duration: 1.0, position: .center)
                    print("HomeVC - getPhotos.failure - error : \(error.rawValue)")
                }
            })
        case 1:
            print("사용자 이름")
        default:
            print("default")
        }
    }
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        var searchBarTitle = ""
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        self.searchBar.placeholder = searchBarTitle + "입력"
        self.searchBar.becomeFirstResponder() // 포커싱 주기
//        self.searchBar.resignFirstResponder() // 포커싱 해제
    }
    
    //MARK: - UISearchBar Delegate methods
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked()")
        guard let userInputString = searchBar.text else { return }
         
        if userInputString.isEmpty {
            self.view.makeToast("📣 검색 키워드를 입력해주세요", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            self.searchButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                //포커싱 해제
                searchBar.resignFirstResponder()
            })
        }else {
            self.searchButton.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn : \(inputTextCount)")
        
        if (inputTextCount >= 12) {
            self.view.makeToast("📢 12자까지만 입력 가능합니다", duration: 1.0, position: .center)
        }
        return inputTextCount <= 12
    }
    
    //MARK: -UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HomeVC - gestureRecog ~ shouldReceiver")
        if(touch.view?.isDescendant(of: searchFilterSegment) == true){
            print("세그먼트가 터치되었다.")
            return false
        } else if (touch.view?.isDescendant(of: searchBar) == true) {
            print("서치바가 터치되었다")
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
}

