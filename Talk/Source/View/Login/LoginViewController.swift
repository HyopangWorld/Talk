//
//  LoginViewController.swift
//  Talk
//
//  Created by 김효원 on 30/09/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            self.changeRootViewMainViewController()
        }
        
        initUI()
        initSet()
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
        loginButton.backgroundColor = UIColor(hex: color!)
        signupButton.backgroundColor = UIColor(hex: color!)
    }
    
    override func initSet() {
        loginButton.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
    }
    
    
    // MARK: - 로그인
    @objc func doLogin(){
        guard let email = email.text, let password = password.text else {
            self.showAlert(title: "정보 입력", message: "정보를 입력하세요.",
                           action: UIAlertAction(title: "확인", style: .default, handler: nil))
            return
        }
        
        showIndicator()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            self.hideIndicator()
            
            if err != nil{
                self.showAlert(title: "로그인 실패", message: err.debugDescription,
                          action: UIAlertAction(title: "확인", style: .default, handler: nil))
                return
            } else {
                if Auth.auth().currentUser != nil {
                    self.changeRootViewMainViewController()
                }
            }
        })
    }
    
    
    // MARK: - 회원가입
    @objc func presentSignup(){
        let signupVC = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(signupVC, animated: true, completion: nil)
    }
}
