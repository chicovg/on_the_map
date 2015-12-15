//
//  UsersTableViewController.swift
//  On The Map
//
//  Created by Victor Guthrie on 11/4/15.
//  Copyright © 2015 chicovg. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    let kTableToInfoPostView = "tableToInfoPostView"
    let reuseIdentifier = "studentLocationCell"
    
    var locations: [StudentLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(StudentLocationCache.sharedInstance.loaded) {
            tableView.reloadData()
        } else {
            refreshLocations()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier == kTableToInfoPostView {
            if let infoVC = segue.destinationViewController as? InfoPostingViewController {
                infoVC.cancelSegue = kUnwindToTableSeque
            }
        }
    }
    
    // MARK: Actions
    @IBAction func addLocation(sender: UIBarButtonItem) {
        performSegueWithIdentifier(kTableToInfoPostView, sender: nil)
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
    @IBAction func refreshLocations(sender: UIBarButtonItem) {
        refreshLocations()
    }
    
    @IBAction func unwindToTableView(unwindSeque: UIStoryboardSegue) {
        refreshLocations()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return StudentLocationCache.sharedInstance.locations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        let loc: StudentLocation = StudentLocationCache.sharedInstance.locations[indexPath.row]
        cell.textLabel?.text = "\(loc.firstName) \(loc.lastName)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let loc: StudentLocation = StudentLocationCache.sharedInstance.locations[indexPath.row]
        if let url = NSURL(string: loc.mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: helpers
    private func refreshLocations() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ParseClient.sharedInstance.getStudentLocations({
            locations in
                print("fetched \(locations.count) locations")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                StudentLocationCache.sharedInstance.updateLocations(locations)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }) { () -> Void in
                print("Could not fetch locations")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                dispatch_async(dispatch_get_main_queue(), {
                    self.displayAlert("Error", message: "Could not download locations.", actionTitle: "Dismiss")
            })
        }
    }
    
    private func displayAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
