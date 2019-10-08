//
//  SharedData.swift
//  Talk
//
//  Created by 김효원 on 2019/10/08.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import Foundation

public class SharedData: NSObject {
    
    public static let shared: SharedData = SharedData()
    
    override public init() {
        
    }
}


// MARK: - SharedData
extension SharedData {
    
    
    // MARK: - 계정 정보
    func getUid() -> String? {
        return UserDefaults.standard.string(forKey: "uid")
    }
    
    func setUid(uid: String) {
        UserDefaults.standard.set(uid, forKey: "uid")
    }
}
