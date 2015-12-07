//
//  InfoPostingMapViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/23/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingMapViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var infoPostMapView: MKMapView!
    @IBOutlet weak var urlValue: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    let kUrlValuePlaceholder = "Enter a Link to Share Here"
    
    var cancelSegue: String?
    var currentCoordinate: CLLocationCoordinate2D?
    var placeName: String?
    var studentInfo: StudentInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get user info to construct post
        if let userKey = UdacityClient.sharedInstance.currentUserKey, coordinate = currentCoordinate {
            UdacityClient.sharedInstance.getUserData(userKey, successHandler: {
                studentInfo in
                    self.studentInfo = studentInfo
                
                    // place pin on map and zoom in
                    let annotation = LocationAnnotation(name: "\(studentInfo.firstName) \(studentInfo.lastName)", url: "", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    self.infoPostMapView.addAnnotation(annotation)
                    let span = MKCoordinateSpanMake(2.0, 2.0)
                    let region = MKCoordinateRegionMake(coordinate, span)
                    self.infoPostMapView.setRegion(region, animated: true)
                }, failureHandler: {
                    void in
                    print("Could not get student info")
                })
        }
        
        
        urlValue.delegate = self
        urlValue.text = kUrlValuePlaceholder
        urlValue.textAlignment = NSTextAlignment.Center
        submitButton.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func submitPost(sender: UIButton) {
        if let coordinate = currentCoordinate, placeName = placeName, studentInfo = studentInfo, url = urlValue.text {
            let studenLocation = StudentLocation(uniqueKey: studentInfo.uniqueKey, firstName: studentInfo.firstName, lastName: studentInfo.lastName, mapString: placeName, mediaURL: url, latitude: coordinate.latitude, longitude: coordinate.longitude)
            ParseClient.sharedInstance.postStudentLocation(studenLocation, successHandler: {
                    void in
                    print("successfully created new student location")
                }, failureHandler: {
                    void in
                    print("failure creating student location")
                })
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        if let segue = cancelSegue {
            performSegueWithIdentifier(segue, sender: nil)
        }
    }
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        if urlValue.text == kUrlValuePlaceholder {
            urlValue.text = ""
        }
        urlValue.textAlignment = NSTextAlignment.Natural
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if urlValue.text == "" {
            urlValue.text = kUrlValuePlaceholder
        }
        urlValue.textAlignment = NSTextAlignment.Center
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
