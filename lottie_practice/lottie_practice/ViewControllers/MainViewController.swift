//
//  ViewController.swift
//  lottie_practice
//
//  Created by 박소현 on 2020/11/29.
//  Copyright © 2020 sohyeon. All rights reserved.
//

import UIKit
import Lottie

class MainViewController: UIViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "안녕하세요"
        label.font = UIFont.boldSystemFont(ofSize: 70)
        return label
    }()
    
    let animationView: AnimationView = {
        let animView = AnimationView(name: "37725-loading-50-among-us")
        animView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animView.contentMode = .scaleAspectFill
        
        return animView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(animationView)
        animationView.center = view.center
        //애니메이션 실행
        animationView.play { (finish) in
            //애니메이션이 끝났을 때
            //애니메이션뷰 지움
            self.animationView.removeFromSuperview()
            
            self.view.addSubview(self.titleLabel)
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            
        }
    }


}

