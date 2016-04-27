//
//  SmartThings.swift
//  SmartStreetAdmin
//
//  Created by Shrutee Gangras on 4/26/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//

import UIKit

class SmartThings {
    
    var id:String
    var status:Bool
    
    init(id:String, status:Bool){
        self.id = id
        self.status = status
        
    }

}


class SmartTrees: SmartThings {
     override init(id:String, status:Bool){
        super.init(id: id, status: status)
    }
    
}


class Sensors: SmartThings {
   
    var treeId:String
    
     init(id:String, status:Bool, treeId:String){
        self.treeId = treeId
        super.init(id: id, status: status)
    }
    
}

