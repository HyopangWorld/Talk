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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = comments[indexPath.row].message
        
        return cell
    }
    
}
