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
    
    @IBOutlet weak var loginButton: UIButton!
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.placeholder = "Enter Username"

        loginButton.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostView" {
            let postViewController = segue.destination as! PostViewController
            postViewController.id = self.id
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        id = idTextField.text!
        //print(id)
        //print("loginDone")
    }
    


}

