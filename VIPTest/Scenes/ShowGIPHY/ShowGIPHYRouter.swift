//
//  ShowGIPHYRouter.swift
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

@objc protocol ShowGIPHYRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ShowGIPHYDataPassing
{
  var dataStore: ShowGIPHYDataStore? { get }
}

class ShowGIPHYRouter: NSObject, ShowGIPHYRoutingLogic, ShowGIPHYDataPassing
{
  weak var viewController: ShowGIPHYViewController?
  var dataStore: ShowGIPHYDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ShowGIPHYViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ShowGIPHYDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
