//
//  GIPHY.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import Foundation

struct GIPHY
{
    var title: String?
    var id: String?
    var url: String?
    var data: Data?
    
}

func GIPHYFromDic(dict: [String:Any?]) -> GIPHY{
    var images = dict["images"] as! [String : Any?]
    var fixed_height_still = images["fixed_height"] as! [String : String?]
    
    var url :String? = fixed_height_still["url"] as? String
    
    return GIPHY(title: dict["title"] as? String, id: dict["id"]as? String, url: url, data: nil)
}
