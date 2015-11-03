//
//  LoginViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/2/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var udacityClient: UdacityClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        udacityClient = UdacityClient()
        
        // REMOVE Before committing!!!!
        emailTextField.text = "guthrievictor@gmail.com"
        passwordTextField.text = "22Chicks"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    // MARK: Actions
    
    @IBAction func login(sender: UIButton) {
        if let email = emailTextField.text, password = passwordTextField.text {
            udacityClient.postNewSession(email, password: password, completionHandler: { () -> Void in
                print("request completed!")
            })
        }
        
    }

    @IBAction func gotoSignUp(sender: UIButton) {
        // launch registration page in browser
    }
}
