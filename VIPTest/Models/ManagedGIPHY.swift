//
//  ManagedGIPHY.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import Foundation
import CoreData

class ManagedGIPHY: NSManagedObject
{

    func toGIPHY() -> GIPHY
    {
        return GIPHY(title: title, id: id, url: url, data: data)
    }
    
    func fromGIPHY(giphy: GIPHY)
    {
        self.id = giphy.id
        self.title = giphy.title
        self.url = giphy.url
        self.data = giphy.data
    }
}

