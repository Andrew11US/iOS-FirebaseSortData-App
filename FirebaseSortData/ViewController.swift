//
//  ViewController.swift
//  FirebaseSortData
//
//  Created by Andrew Foster on 3/26/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var msgField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var msgs = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.msgField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DataService.ds.MSGS_DB_REF.queryOrdered(byChild: "postedDate").observe(.value, with: { (snapshot) in
            
            self.msgs = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String: AnyObject] {
                        let message = Message(msgId: snap.key, msgData: postDict)
                        self.msgs.append(message)
                        
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        msgField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = msgs[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell {
            cell.configureCell(msg: msg)
            return cell
        } else {
            return MessageCell()
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: AnyObject) {
        
        if let msgText = msgField.text , !msgText.isEmpty {
            let msg = [
                "text": msgText,
                "postedDate": FIRServerValue.timestamp()
                ] as [String : Any]
            
            let fireMsg = DataService.ds.MSGS_DB_REF.childByAutoId()
            fireMsg.setValue(msg)
            
            msgField.text = ""
            tableView.reloadData()
        }
        
    }

}

