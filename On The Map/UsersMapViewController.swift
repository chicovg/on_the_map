//
//  UsersMapViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/4/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit

class UsersMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: Navigation

    // MARK: Actions
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance.deleteSession({() -> Void in
            print("logged out")
            // segue to login view
        }) { () -> Void in
            print("could not log out!")
            // segue to login view
        }
    }

}
