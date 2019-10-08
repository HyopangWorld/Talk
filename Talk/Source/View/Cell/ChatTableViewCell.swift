//
//  ChatTableViewCell.swift
//  Talk
//
//  Created by 김효원 on 07/10/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {
    @IBOutlet weak var message: UILabel!
    
    override func prepareForReuse() {
        message.text = nil
    }
}

class DestinationMessageCell: UITableViewCell {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    
    override func prepareForReuse() {
        message.text = nil
        name.text = nil
    }
}

