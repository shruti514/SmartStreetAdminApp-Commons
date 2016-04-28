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
    
    init(id:String){
        self.id = id
    }

}


class SmartTrees: SmartThings {
     override init(id:String){
        super.init(id: id)
    }
    
}


class Sensors: SmartThings {
   
    var treeId:String!
    
     override init(id:String){
        super.init(id: id)
    }
    
}

