//
//  Deploy.swift
//  SmartStreetAdmin
//
//  Created by Anhad S Bhasin on 5/2/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//

import UIKit
import Parse

class Deploy: UITableViewController {

    
    var treeId:String!
    var sensorId:String!
    var isTreeDetails = true
    var currentDate:NSDate!
    
    @IBOutlet weak var SmartStreetID: UITextField!
    @IBOutlet weak var Lattitude: UITextField!
    @IBOutlet weak var Longitude: UITextField!
    @IBOutlet weak var Date: UITextField!
    
    @IBOutlet weak var Installed: UISwitch!
    
    @IBAction func Submit() {
        
        
//        let id =
        let deploy = PFObject(className: "TreeDeployment")
        deploy["TreeId"] = SmartStreetID.text
        deploy["Latitude"] = Lattitude.text
        deploy["Longitude"] = Longitude.text
        deploy["Date"] = Date.text
        deploy["Status"] = Installed.on
        
        
        deploy.saveInBackgroundWithBlock {(success:Bool, error:NSError?) in
            if (success) {
                print("Deployment record saved to database")
                let alert = UIAlertController(title: "Success", message: "Deployment Successful", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: { action in print("Pass Alert Shown")}))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.reset()
                
            } else {
                
                print("Error")
                let alert = UIAlertController(title: "Failed", message: "Deployment Unsuccessful", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Done",
                    style: UIAlertActionStyle.Default,
                    handler: {(alert: UIAlertAction!) in print("Fail Alert Shown")}))
                self.presentViewController(alert, animated: true, completion: nil)
                self.reset()
                
                
            }
        }

        
    }
    
    override func viewDidLoad() {
        
        
        
    }
    func reset(){
        SmartStreetID.text = ""
        Lattitude.text = ""
        Longitude.text =  ""
        Date.text = ""
        Installed.on = true
    }
    
}
