//
//  PostViewController.swift
//  TechChanApp
//
//  Created by Haruko Okada on 9/21/20.
//  Copyright © 2020 Haruko Okada. All rights reserved.
//
 
import UIKit
import FirebaseDatabase

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
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

        // Do any additional setup after loading the view.
        
        postTextView.layer.cornerRadius = 5
        
        //ログインでidを記入しなかったら匿名と表示される
        if id == ""{
            id = "匿名"
        }
        idLabel.text = "ID: \(id)"
        

        ref.observe(DataEventType.value, with: {(DataSnapshot)in
            

            if DataSnapshot.childrenCount > 0 {

                //表示がダブらないように一旦配列を空にする
                self.postArray.removeAll()
                
                //firebaseのデータを読み込んで配列に入れる
                for postData in DataSnapshot.children.allObjects as! [DataSnapshot] {
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
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func postBtn(_ sender: Any) {
        postContent = postTextView.text!
        addPosts()
        postTextView.text = ""
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
