//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/21/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var placeName: UITextView!
    
    let locationManager = CLLocationManager()
    let kinfoPostToPostMapViewSegue = "infoPostToPostMapView"
    
    var cancelSegue: String?
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == kinfoPostToPostMapViewSegue && currentCoordinate != nil {
            if let postMapVC = segue.destinationViewController as? InfoPostingMapViewController {
                postMapVC.cancelSegue = cancelSegue
                postMapVC.currentCoordinate = currentCoordinate
            }
        }
    }
    

    // MARK: Actions
    @IBAction func cancelPost(sender: UIButton) {
        if let segue = cancelSegue {
            performSegueWithIdentifier(segue, sender: nil)
        }
    }

    @IBAction func findPlaceOnMap(sender: UIButton) {
        currentCoordinate = nil
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            // transition to map with location
            currentCoordinate = loc.coordinate
            performSegueWithIdentifier(kinfoPostToPostMapViewSegue, sender: nil)
        } else {
            print("No locations returned!")
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}
