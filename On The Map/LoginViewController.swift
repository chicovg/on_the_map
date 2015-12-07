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
    let kSegueToMapAndTableId = "segueToMapAndTable"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // REMOVE Before committing!!!!
        emailTextField.text = "guthrievictor@gmail.com"
        passwordTextField.text = "UBHDKhYPQtF1a78N"
        
        emailTextField.leftView = UIView.init(frame: CGRectMake(0, 0, 5, 20))
        emailTextField.leftViewMode = UITextFieldViewMode.Always
        
        passwordTextField.leftView = UIView.init(frame: CGRectMake(0, 0, 5, 20))
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
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
            UdacityClient.sharedInstance.postNewSession(email, password: password, successHandler: { () -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier(self.kSegueToMapAndTableId, sender: nil)
                })
            }, failureHandler:  { () -> Void in
                self.displayAlert("Error", message: "Login Failed", actionTitle: "Dismiss")
            })
        }
        
    }

    @IBAction func gotoSignUp(sender: UIButton) {
        // launch registration page in browser
    }
    
    @IBAction func unwindToLoginView(unwindSeque: UIStoryboardSegue) {
        
    }
    
    private func displayAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
