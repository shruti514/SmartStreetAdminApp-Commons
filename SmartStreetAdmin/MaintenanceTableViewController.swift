//
//  MaintenanceTableViewController.swift
//  SmartStreetAdmin
//
//  Created by Shrutee Gangras on 4/26/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//
import UIKit
import Parse

class MaintenanceTableViewController: UITableViewController {
    
    var maitenanceRecords : [MaintenanceRecords]=[]
    
   
    var selectedTreeIndex : Int = 0
    
    override func viewDidLoad() {
        self.loadMaintenanceRecords()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return maitenanceRecords.count
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maitenanceRecords[section].records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        indexPath.section
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MaintenanceTableCell", forIndexPath: indexPath) as! MaintenanceTableViewCell
        let section = maitenanceRecords[indexPath.section]
        let smartThing = section.records[indexPath.row]
        cell.titleLabel.text = smartThing.id
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = maitenanceRecords[section]
        return section.recordType
    }
    
    
    func loadMaintenanceRecords(){
        self.fetchTreeRecords()
    }
    
    private  func fetchSensorRecords(forTree:SmartThings){
        var records:[SmartThings]=[]
        
        let query = PFQuery(className: "SensorDeployment")
        // query.whereKey("TreeId", equalTo: tree.id)
        query.orderByAscending("SensorId")
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for sensor in results!{
                    let id = sensor["SensorId"] as! String
                    let treeId = sensor["TreeId"] as! String
                    let status = sensor["Status"] as! Bool
                    let smartThing = Sensors(id:id, status:status, treeId: treeId)
                    records.append(smartThing)
                }
            }
            if(self.maitenanceRecords.count>=2){
                self.maitenanceRecords[1]=(MaintenanceRecords(recordType: "Sensor Maintemance", records: records))
            }else{
                self.maitenanceRecords.append(MaintenanceRecords(recordType: "Sensor Maintemance", records: records))
            }
            self.tableView.reloadData()
            
        }
    }
    
    
    private  func fetchTreeRecords(){
        var records:[SmartThings]=[]
        
        let query = PFQuery(className: "TreeDeployment")
        query.orderByAscending("TreeId")
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for tree in results!{
                    let id = tree["TreeId"] as! String
                    let status = tree["Status"] as! Bool
                    let smartThing = SmartTrees(id:id, status:status)
                    records.append(smartThing)
                }
            }
            if(self.maitenanceRecords.count>=2){
                self.maitenanceRecords[0] = MaintenanceRecords(recordType: "Tree Maintemance", records: records)
            }else{
                self.maitenanceRecords.append(MaintenanceRecords(recordType: "Tree Maintemance", records: records))
            }
            
            self.fetchSensorRecords(records[self.selectedTreeIndex])
        }
    }
}

