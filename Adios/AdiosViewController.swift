//
//  AdiosViewController.swift
//  Adios
//
//  Created by Armand Grillet on 16/08/2015.
//  Copyright © 2015 Armand Grillet. All rights reserved.
//

import UIKit

class AdiosViewController: UIViewController {
    let onboardManager = OnboardManager()
    
    @IBOutlet weak var configurationState: UILabel!
    @IBOutlet weak var lastUpdateButton: UIButton!
    
    @IBOutlet weak var configureButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AdiosViewController.foregroundNotification(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AdiosViewController.longPressOnConfigure(_:)))
        configureButton.addGestureRecognizer(longPressRecognizer)
        displayAdiosState()
    }
    
    func displayAdiosState() {
        let followedLists = ListsManager.getFollowedLists()
        if followedLists != [] {
            configurationState.text = NSLocalizedString("Adios is configured", comment: "Adios is configured")
            if let lastUpdateTimestamp = NSUserDefaults.standardUserDefaults().objectForKey("lastUpdateTimestamp") {
                let formatter = NSDateFormatter()
                formatter.timeStyle = .ShortStyle
                formatter.dateStyle = .ShortStyle
                lastUpdateButton.setTitle(NSLocalizedString("Last download:", comment: "Presentation fo the last download") + " " + formatter.stringFromDate(lastUpdateTimestamp as! NSDate), forState: .Normal)
                lastUpdateButton.enabled = true
            } else {
                configurationState.text = NSLocalizedString("Error timestamp", comment: "Weird error due to the use of 3G instead of Wifi")
                lastUpdateButton.enabled = false
                lastUpdateButton.setTitle("", forState: .Disabled)
            }
        } else {
            configurationState.text = NSLocalizedString("Configure Adios first", comment: "Adios doesn't blocks ads, the user needs to configure it first")
            lastUpdateButton.enabled = false
            lastUpdateButton.setTitle("", forState: .Disabled)
        }
    }
    
    func foregroundNotification(notification:NSNotification?) {
        displayAdiosState()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayAdiosState()
    }
    
    @IBAction func longPressOnConfigure(sender: UILongPressGestureRecognizer) {
        self.performSegueWithIdentifier("Advanced", sender: self)
    }
    
    @IBAction func updateLists(sender: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("Update the lists?", comment: "Asking the user if he wants to update the list"), message: "", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Button label to cancel something"), style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.performSegueWithIdentifier(NSLocalizedString("Update", comment: "Button label to update the list"), sender: self)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Configure" || segue.identifier == "Advanced" {
            onboardManager.reset()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
}


