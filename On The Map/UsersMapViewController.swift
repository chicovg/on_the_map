//
//  UsersMapViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/4/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit
import MapKit

class UsersMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let kMapToInfoPostView = "mapToInfoPostView"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        getLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == kMapToInfoPostView {
            if let infoVC = segue.destinationViewController as? InfoPostingViewController {
               infoVC.cancelSegue = kUnwindToMapSeque
            }
        }
    }

    // MARK: Actions
    @IBAction func addLocation(sender: UIBarButtonItem) {
        performSegueWithIdentifier(kMapToInfoPostView, sender: nil)
    }
    
    @IBAction func refreshLocations(sender: UIBarButtonItem) {
        getLocations()
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance.deleteSession({() -> Void in
            print("logged out")
            self.performSegueWithIdentifier(kUnwindToLoginView, sender: nil)
        }) { () -> Void in
            print("could not log out!")
            self.performSegueWithIdentifier(kUnwindToLoginView, sender: nil)
        }
    }
    
    @IBAction func unwindToMapView(unwindSeque: UIStoryboardSegue) {}
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? LocationAnnotation {
            let annotationView = MKPinAnnotationView()
            let infoButton = UIButton(type: UIButtonType.DetailDisclosure)
            annotationView.rightCalloutAccessoryView = infoButton
            annotationView.canShowCallout = true
            annotationView.pinTintColor = UIColor.redColor()
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? LocationAnnotation {
            if let url = NSURL(string: annotation.url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: helpers
    private func getLocations() {
        ParseClient.sharedInstance.getStudentLocations({
            locations in
            print("fetched locations")
            dispatch_async(dispatch_get_main_queue(), {
                for loc in locations {
                    let annotation = LocationAnnotation(name: "\(loc.firstName) \(loc.lastName)", url: loc.mediaURL, coordinate: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude))
                    
                    self.mapView.addAnnotation(annotation)
                }
            })
        }) { () -> Void in
                print("Could not fetch locations")
        }
    }

}
