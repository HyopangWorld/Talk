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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupbutton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        signupbutton.backgroundColor = UIColor(hex: color!)
        cancleButton.backgroundColor = UIColor(hex: color!)
    }
    
    override func initSet() {
        super.initSet()
        
        photoView.isUserInteractionEnabled = true
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        signupbutton.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancleButton.addTarget(self, action: #selector(cancleEvent), for: .touchUpInside)
    }
    
    
    // MARK: - 가입 취소
    @objc func cancleEvent(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - 이미지 선택 열기
    @objc func imagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - 회원 가입
    @objc func signupEvent(){
        guard let userName = userName.text, let email = email.text, let password = password.text else {
            self.showAlert(title: "정보 입력", message: "정보를 입력하세요.",
                           action: UIAlertAction(title: "확인", style: .default, handler: nil))
            return
        }
        
        showIndicator()
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            guard let uid = user?.user.uid else {
                self.showAlert(title: "데이터 오류", message: "회원정보를 확인하세요.",
                               action: UIAlertAction(title: "확인", style: .default, handler: nil))
                return
            }
            
            let image = self.photoView.image?.jpegData(compressionQuality: CGFloat(0.1))
            let starsRef = Storage.storage().reference().child("userImages").child(uid)
            
            starsRef.putData(image!, metadata: nil, completion: { (data, err) in
                if err != nil {
                    return
                }
                
                starsRef.downloadURL { (url, err) in
                    if err != nil {
                        return
                    }
                    
                    guard let imageURL = url?.absoluteString else {
                         self.showAlert(title: "데이터 오류", message: "프로필 사진을 확인하세요.",
                                        action: UIAlertAction(title: "확인", style: .default, handler: nil))
                         return
                     }
                                                                          
                    let value = ["uid": Auth.auth().currentUser?.uid, "userName": userName, "profileImageUrl": imageURL]
                     Database.database().reference().child("users").child(uid).setValue(value, withCompletionBlock: { (err, ref) in
                            self.hideIndicator()
                            self.showAlert(title: "", message: "회원가입이 완료되었습니다.",
                                           action: UIAlertAction(title: "확인", style: .default, handler: { _ in
                                                self.cancleEvent()
                                            }))
                     })
                }
            })
        }
        
    }
    
}


extension SignupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
}
