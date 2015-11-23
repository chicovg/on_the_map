//
//  InfoPostingMapViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/23/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingMapViewController: UIViewController {

    
    @IBOutlet weak var infoPostMapView: MKMapView!
    @IBOutlet weak var urlValue: UITextView!
    
    var cancelSegue: String?
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender: UIButton) {
    }
}
