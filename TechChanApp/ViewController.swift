//
//  ViewController.swift
//  TechChanApp
//
//  Created by Haruko Okada on 9/21/20.
//  Copyright © 2020 Haruko Okada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostView" {
            let postViewController = segue.destination as! PostViewController
            postViewController.id = self.id
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        id = idTextField.text!
        //print(id)
        //print("loginDone")
    }
    


}

