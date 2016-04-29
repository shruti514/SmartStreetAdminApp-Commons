//
//  MonitorViewController.swift
//  SmartStreetAdmin
//
//  Created by Vidya Khadsare on 4/29/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//

import UIKit
import Parse

class MonitorViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var sensorObjectIds = [String]()
        var treeObjectIds = [String]()
        var statusObjectIds = [String]()
        

        let monitorRecord = PFQuery(className: "SensorDeployment")
        monitorRecord.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        sensorObjectIds.append(String(object.valueForKey("SensorId")!))
                        treeObjectIds.append(String(object.valueForKey("TreeId")!))
                        statusObjectIds.append(String(object.valueForKey("Status")!))
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
            
            print(sensorObjectIds)
            print(treeObjectIds)
            print(statusObjectIds)
        }
    }
    
}
