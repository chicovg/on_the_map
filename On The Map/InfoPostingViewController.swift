//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/21/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {

    @IBOutlet weak var placeName: UITextView!
    
    var cancelSegue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Actions
    @IBAction func cancelPost(sender: UIButton) {
        if let segue = cancelSegue {
            performSegueWithIdentifier(segue, sender: nil)
        }
    }

    @IBAction func findPlaceOnMap(sender: UIButton) {
        
    }
}
