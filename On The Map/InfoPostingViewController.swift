//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/21/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostingViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var placeName: UITextView!
    @IBOutlet weak var findOnMap: UIButton!
    
    let geocoder = CLGeocoder()
    let kinfoPostToPostMapViewSegue = "infoPostToPostMapView"
    let kPlaceNamePlaceholder = "Enter Your Location Here"
    
    var cancelSegue: String?
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        placeName.delegate = self
        placeName.text = kPlaceNamePlaceholder
        placeName.textAlignment = NSTextAlignment.Center
        findOnMap.layer.cornerRadius = 8
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
        if let text = placeName.text {
            geocoder.geocodeAddressString(text, completionHandler:  {
                placemarks, error in
                if let err = error {
                    print("Error geocoding location \(err)")
                    self.displayAlert("Error", message: "Cannot find that location!", actionTitle: "Try Again")
                } else if let placemarks = placemarks, let pm = placemarks.first, let loc = pm.location {
                    self.currentCoordinate = loc.coordinate
                    self.performSegueWithIdentifier(self.kinfoPostToPostMapViewSegue, sender: nil)
                }
                self.placeName.text = self.kPlaceNamePlaceholder
            })
        }
    }
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == kPlaceNamePlaceholder {
            textView.text = ""
        }
        textView.textAlignment = NSTextAlignment.Natural
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = kPlaceNamePlaceholder
        }
        textView.textAlignment = NSTextAlignment.Center
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func displayAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
