//
//  ChatViewController+TableView.swift
//  Talk
//
//  Created by 김효원 on 02/10/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    //DestinationMessageCell  MyMessageCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if self.comments[index].uid == uid {
            let myCell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            myCell.selectionStyle = .none
            myCell.message.text = comments[indexPath.row].message
            
            return myCell
        }
        else {
            let destCell = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            destCell.selectionStyle = .none
            destCell.message.text = comments[indexPath.row].message
            destCell.name.text = destinationUser?.userName
            
            URLSession.shared.dataTask(with: URL(string: destinationUser!.profileImageUrl!)!) { (data,response, err) in
                DispatchQueue.main.async {
                    destCell.profile_image.image = UIImage(data: data!)
                    destCell.profile_image.layer.cornerRadius = destCell.profile_image.frame.size.width / 2
                    destCell.profile_image.clipsToBounds = true
                }
            }.resume()
            
            return destCell
        }
    }
    
}
