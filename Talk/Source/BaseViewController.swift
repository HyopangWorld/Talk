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
    
    func initUI(){
        // Initalize UI setting
    }
    
    func initSet(){
        // Initalize setting etc.
    }
    
    func showAlert(title: String, message: String, action: UIAlertAction? ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if action != nil {
            alert.addAction(action!)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
