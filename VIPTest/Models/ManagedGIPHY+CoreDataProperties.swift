//
//  ManagedGIPHY+CoreDataProperties.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import Foundation
import CoreData

extension ManagedGIPHY {
    
    @NSManaged var id: String?
    @NSManaged var data: Data?
    @NSManaged var title: String?
    @NSManaged var url: String?
}
