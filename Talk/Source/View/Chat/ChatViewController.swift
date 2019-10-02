//
//  ChatViewController.swift
//  Talk
//
//  Created by 김효원 on 02/10/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    var destinationUid: String? // 상대방
    var uid: String?
    var chatRoomUid: String?
    var comments: [Chat.Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSet()
    }
    
    override func initSet() {
        uid = Auth.auth().currentUser?.uid
        
        sendButton.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
    }
    
    
    // MARK: - 채팅방 생성
    @objc func createRoom() {
        guard let message = messageTextField.text else {
            return
        }
        
        // 채팅방 생성
        guard let chatRoomUid = chatRoomUid else {
            self.sendButton.isEnabled = false
            
            let createRoomInfo: Dictionary<String, Any> = [ "users": [
                    uid!: true,
                    destinationUid!: true
                ]
            ]
            
            Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo) { (err, ref) in
                if err == nil {
                    self.checkChatRoom()
                }
            }
            return
        }
        
        // 이미 채팅방이 존재할 경우
        let value: Dictionary<String, Any> = [
            "uid": uid!,
            "message" : message
        ]
        
        Database.database().reference().child("chatrooms").child(chatRoomUid).child("comments").childByAutoId().setValue(value)
    }
    
    
    // MARK: - 채팅방 존재 여부 확인
    func checkChatRoom() {
        Database.database().reference().child("chatrooms")
            .queryOrdered(byChild: "users/\(uid!)").queryEqual(toValue: true)
            .observeSingleEvent(of: DataEventType.value) { (datasnapshot) in
            
                for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                    guard let chatRoomDic = item.value as? [String:AnyObject] else {
                        return
                    }
                    
                    let chat = Chat(JSON: chatRoomDic)
                    if (chat?.users[self.destinationUid!]) != nil {
                        self.chatRoomUid = item.key
                        self.sendButton.isEnabled = true
                        self.getMessageList()
                    }
                }
        }
    }
    
    
    // MARK: - 메세지 가져오기
    func getMessageList(){
        guard let chatRoomUid = chatRoomUid else {
            return
        }
        
        Database.database().reference().child("chatrooms").child(chatRoomUid).child("comments")
            .observe(DataEventType.value) { (datasnapshot) in
                self.comments.removeAll()
                
                for item in datasnapshot.children.allObjects as! [DataSnapshot] {
                    guard let comment = Chat.Comment(JSON: item.value as! [String:AnyObject]) else {
                        return
                    }
                    
                    self.comments.append(comment)
                }
                
                self.tableView.reloadData()
            }
    }
}
