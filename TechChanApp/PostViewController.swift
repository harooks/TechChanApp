//
//  PostViewController.swift
//  TechChanApp
//
//  Created by Haruko Okada on 9/21/20.
//  Copyright © 2020 Haruko Okada. All rights reserved.
//
 
import UIKit
import FirebaseDatabase

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    
    var postContent: String = ""
    var id: String = ""

    let ref = Database.database().reference()
    
    //Post class の配列
    var postArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTextView.layer.cornerRadius = 5
    
        //ログインでidを記入しなかったら匿名と表示される
        if id.isEmpty {
            id = "匿名"
        }
        idLabel.text = "ID: \(id)"
        

        ref.observe(DataEventType.value, with: {(dataSnapshot)in
            

            if dataSnapshot.childrenCount > 0 {

                //表示がダブらないように一旦配列を空にする
                self.postArray.removeAll()
                
                //firebaseのデータを読み込んで配列に入れる
                for postData in dataSnapshot.children.allObjects as! [DataSnapshot] {
                    let postObject = postData.value as? [String: AnyObject]
                    let usernameElement = postObject?["username"]
                    let postElement = postObject?["post"]
                    
                    //make Post class
                    let postModel = Post(username: usernameElement as? String, post: postElement as? String)
                    
                    //配列に Post のオブジェクトを追加
                    self.postArray.append(postModel)
                    
                    //セルを上から入れるため配列を逆にする
                    self.postArray.reverse()
                }
                  self.postTableView.reloadData()
           }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil);

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func postBtn(_ sender: Any) {
        postContent = postTextView.text!
        addPosts()
        postTextView.text = ""
        hideKeyboard()
    }
    
    //Firebaseにデータをkakikomu
    func addPosts(){
        let postData = ["username": id, "post": postContent]
        ref.childByAutoId().setValue(postData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        let newPost: Post
        newPost = postArray[indexPath.row]
        
        //セルのラベルの表示
        cell.usernameLabel.text = newPost.username
        cell.postContentLabel.text = newPost.post
        return cell
    }
    
    //dynamic tableview cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    postTableView.estimatedRowHeight = 120
       return UITableView.automaticDimension
    }
    
    func hideKeyboard() {
        postTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
