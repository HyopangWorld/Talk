//
//  ViewController.swift
//  Talk
//
//  Created by 김효원 on 30/09/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ViewController: BaseViewController {
    
    var box = UIImageView()
    var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initSet()
    }
    
    override func initUI(){
        box.image = #imageLiteral(resourceName: "icon")
    }
    
    override func initSet(){
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate(completionHandler: { (error) in
                    // ...
                })
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        
        self.view.addSubview(box)
        box.snp.makeConstraints({ (make) in
            make.center.equalTo(self.view)
        })
    }
    
    func displayWelcome(){
        let color = remoteConfig["splash_background"].stringValue
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue
        
        if caps {
            self.showAlert(title: "공지사항", message: message!, action: UIAlertAction(title: "확인", style: .default, handler: { action in
                exit(0)
            }))
        } else {
    
            changeRootViewLoginViewController()
        }
        
        self.view.backgroundColor = UIColor(hex: color!)
    }
    
    func changeRootViewLoginViewController() {
        let setMainRoot = UIApplication.shared.delegate as! AppDelegate
        let window = setMainRoot.window

        let loginNavigationVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        window?.rootViewController = loginNavigationVC
        window?.makeKeyAndVisible()
    }
}

