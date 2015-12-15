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
    let kUdacityRegistrationPage = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        if segue.identifier == kSegueToMapAndTableId {
            
        }
    }
    
    // MARK: Actions
    @IBAction func login(sender: UIButton) {
        if let email = emailTextField.text, password = passwordTextField.text {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            UdacityClient.sharedInstance.postNewSession(email, password: password, successHandler: { () -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.segueToMapAndTable()
            }, failureHandler:  { errorMsg in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.displayUdacityLoginFailedAlert(errorMsg)
            })
        }
    }

    @IBAction func gotoSignUp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: kUdacityRegistrationPage)!)
    }
    
    @IBAction func unwindToLoginView(unwindSeque: UIStoryboardSegue) {
        
    }
    
    private func segueToMapAndTable(){
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier(self.kSegueToMapAndTableId, sender: self)
        })
    }
    
    private func displayUdacityLoginFailedAlert(errorMsg: String){
        dispatch_async(dispatch_get_main_queue(), {
           self.displayAlert("Error", message: "Udacity Login Failed: \(errorMsg)", actionTitle: "Dismiss")
        })
    }
    
    private func displayFacebookLoginFailedAlert(){
        dispatch_async(dispatch_get_main_queue(), {
            self.displayAlert("Error", message: "Facebook Login Failed", actionTitle: "Dismiss")
        })
    }
    
    private func displayAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
