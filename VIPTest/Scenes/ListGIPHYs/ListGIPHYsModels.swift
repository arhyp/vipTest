//
//  ListGIPHYsModels.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright (c) 2017 KoshelGROUP. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ListGIPHYs
{
  // MARK: Use cases
  
  enum FetchList
  {
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct DisplayedGIPHY {
            var url: NSString?
            var data: NSDate?
            var title: NSString?
        }
    }
  }
}
