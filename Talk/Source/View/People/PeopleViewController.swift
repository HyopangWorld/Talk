//
//  MainViewController.swift
//  Talk
//
//  Created by 김효원 on 01/10/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class PeopleViewController: BaseViewController {

    var array: [User] = []
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initSet()
    }


    override func initUI(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ (m) in
            m.top.equalTo(view).offset(20)
            m.bottom.left.right.equalTo(view)
        })
    }
    
    override func initSet(){
        getUsersData()
    }
    
    func getUsersData(){
        Database.database().reference().child("users").observe(DataEventType.value, with:{ (snapshot) in
            self.array.removeAll()
            
            let myUid = Auth.auth().currentUser?.uid
            
            for child in snapshot.children {
                let fchild = child as! DataSnapshot
                let user = User()
                
                user.setValuesForKeys(fchild.value as! [String : Any])
                
                if user.uid == myUid {
                    continue
                }
                
                self.array.append(user)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

}


extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView = UIImageView()
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(25)
            m.height.width.equalTo(50)
        }
        
        URLSession.shared.dataTask(with: URL(string: array[indexPath.row].profileImageUrl!)!) { (data,response, err) in
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
                imageView.layer.cornerRadius = imageView.frame.size.width / 2
                imageView.clipsToBounds = true
            }
        }.resume()
        
        let label = UILabel()
        cell.addSubview(label)
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(imageView.snp.right).offset(15)
        }
        label.text = array[indexPath.row].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.destinationUid = array[indexPath.row].uid
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
