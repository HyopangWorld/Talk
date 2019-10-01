//
//  SignupViewController.swift
//  Talk
//
//  Created by 김효원 on 01/10/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: BaseViewController {
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func initUI() {
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { m in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        color = remoteConfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color!)
    }
    
}
