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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        let newPost: Post
        newPost = postList[indexPath.row]
        
        cell.usernameLabel.text = newPost.username
        cell.postContentLabel.text = newPost.post
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    postTableView.estimatedRowHeight = 120
       return UITableView.automaticDimension
    }
    
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    
    var postContent: String = ""
    var id: String = ""

    let ref = Database.database().reference()
    
    //array to store post data
    var postList = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if id == ""{
            id = "匿名"
        }
        idLabel.text = "ID: \(id)"
        
        ref.observe(DataEventType.value, with: {(DataSnapshot)in
            if DataSnapshot.childrenCount > 0 {
                self.postList.removeAll()
                
                for postData in DataSnapshot.children.allObjects as! [DataSnapshot] {
                    let postObject = postData.value as? [String: AnyObject]
                    let usernameElement = postObject?["username"]
                    let postElement = postObject?["post"]
                    
                    //make Post class
                    let postModel = Post(username: usernameElement as? String, post: postElement as? String)
                    
                    //append to array
                    self.postList.append(postModel)
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
       // self.postTableView.reloadData()
        postTextView.text = ""
    }
    
    func addPosts(){
        let postData = ["username": id, "post": postContent]
        ref.childByAutoId().setValue(postData)
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
