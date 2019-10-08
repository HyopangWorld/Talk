//
//  BaseViewController.swift
//  Talk
//
//  Created by 김효원 on 30/09/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    var indicator: UIActivityIndicatorView?
    
    func initUI(){
        // Initalize UI setting
    }
    
    func initSet(){
        // Initalize setting etc.
    }
    
    
    //MARK: - (공통) indicator
    func showIndicator(){
        if indicator == nil {
            indicator = UIActivityIndicatorView()
            indicator?.color = UIColor.black
            
            if let keywindow = UIApplication.shared.keyWindow {
                self.indicator?.center = keywindow.center
                keywindow.addSubview(self.indicator!)
                keywindow.bringSubviewToFront(self.indicator!)
            }
        }
        
        indicator?.startAnimating()
    }
    
    func hideIndicator(){
        indicator?.stopAnimating()
    }
    
    
    //MARK: - (공통) alert
    func showAlert(title: String, message: String, action: UIAlertAction? ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if action != nil {
            alert.addAction(action!)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - (공통) main root controller 변경
    func changeRootViewMainViewController() {
        let setMainRoot = UIApplication.shared.delegate as! AppDelegate
        let window = setMainRoot.window

        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewTabBarController") as! UITabBarController
        
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
    }
    
    
    //MARK: - (공통) login root controller 변경
    func changeRootViewLoginViewController() {
        let setLoginRoot = UIApplication.shared.delegate as! AppDelegate
        let window = setLoginRoot.window

        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
}
