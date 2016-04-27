//
//  MaintenanceRecords.swift
//  SmartStreetAdmin
//
//  Created by Shrutee Gangras on 4/26/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//
import UIKit
import Parse

class MaintenanceRecords {
    
    var recordType:String
    var records:[SmartThings] = []
    
    init(recordType: String, records: [SmartThings]){
        self.recordType = recordType
        self.records = records
    }
    
}
    
   

