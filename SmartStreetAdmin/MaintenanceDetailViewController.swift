//
//  MaintenanceDetailViewController.swift
//  SmartStreetAdmin
//
//  Created by Shrutee Gangras on 4/27/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//

import UIKit
import Parse

class MaintenanceDetailViewController: UIViewController {
    
    var treeId:String!
    var sensorId:String!
    var isTreeDetails = true
    var currentDate:NSDate!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var maintenanceDetailsText: UITextView!
    
    
    @IBOutlet weak var updateInfo: UIButton!
    
    
    @IBAction func updateButtonPressed(sender: AnyObject) {
        
        let maintenanceRecord = PFObject(className: "Maintenance")
        
        let maintenanceRecordnumber = Int(arc4random_uniform(100) + 1)
        maintenanceRecord["MaintenanceId"] = "M"+String(maintenanceRecordnumber)
        maintenanceRecord["Date"] = self.currentDate
        maintenanceRecord["MaintenanceInfo"] = self.maintenanceDetailsText.text
        if(isTreeDetails){
            maintenanceRecord["TreeId"] = self.treeId
            maintenanceRecord["SensorId"] = NSNull()
        }else{
            maintenanceRecord["TreeId"] = NSNull()
            maintenanceRecord["SensorId"] = self.sensorId
        }        
        
        maintenanceRecord.saveInBackgroundWithBlock { (success:Bool, error:NSError?) in
            if (success) {
                print("Maintenance record saved to database")
                let alert = UIAlertController(title: "Success", message: "Maintenance record updated", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: { action in
                    
                    if let maintenanceTableView = self.storyboard?.instantiateViewControllerWithIdentifier("MaintenanceTableView") as? MaintenanceTableViewController {
                        
                        self.presentViewController(maintenanceTableView, animated: true, completion: nil)
                    }
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                print("Error saving maintenance records.")
                let alert = UIAlertController(title: "Error", message: "Error updating a mantenance record", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: { action in
                    
                    if let maintenanceTableView = self.storyboard?.instantiateViewControllerWithIdentifier("MaintenanceTableView") as? MaintenanceTableViewController {
                        
                        self.presentViewController(maintenanceTableView, animated: true, completion: nil)
                    }
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
                
        }
        }
        
    }
    
    
    func showMaintenanceRecordsView() -> Void{
        if let maintenanceTableView = self.storyboard?.instantiateViewControllerWithIdentifier("MaintenanceTableView") as? MaintenanceTableViewController {
            self.presentViewController(maintenanceTableView, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        
        if(isTreeDetails){
            idLabel.text = "Tree ID: "+treeId
        }else{
            idLabel.text = "Sensor ID: "+sensorId
        }
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle
        self.currentDate = NSDate()
        self.dateLabel.text = dateformatter.stringFromDate(currentDate)
        
    }
}
