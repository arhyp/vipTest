//
//  ListGIPHYsInteractor.swift
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

protocol ListGIPHYsBusinessLogic
{
  func fetchGIPHY(request: ListGIPHYs.FetchList.Request)
}

protocol ListGIPHYsDataStore
{
  //var name: String { get set }
}

class ListGIPHYsInteractor: ListGIPHYsBusinessLogic, ListGIPHYsDataStore
{
  var presenter: ListGIPHYsPresentationLogic?
    var worker: GIPHYWorker = GIPHYWorker(giphyStore: GiphiesMemStore())
    var giphyAPI = GIPHYAPI()
    
    var GIPHIES: [GIPHY]?
  
  
  // MARK: Do something
  
  func fetchGIPHY(request: ListGIPHYs.FetchList.Request)
  {
    if (request.searchString?.isEmpty == false){
    giphyAPI.fetchGIPIESWITH(strSearch: request.searchString!) { (result) in
        do{
            self.GIPHIES = try result()
        }catch{
            self.GIPHIES = [GIPHY]()
        }
        self.addToDB()
        self.sendResponse()
        }
        
    }else {
        self.worker.fetchGIPHIES(completionHandler: { (giphies) in
            self.GIPHIES = giphies
            self.sendResponse()
        })
    }
    
  }
   
    func sendResponse (){
        var response = ListGIPHYs.FetchList.Response()
        response.giphies = self.GIPHIES
        print ("response count \(self.GIPHIES?.count)")
        presenter?.presentSomething(response: response)
    }
    
    func addToDB(){
        if self.GIPHIES == nil {
           return
        }
        for giphy in self.GIPHIES! {
            worker.createGIPHY(giphyToCreate: giphy, completionHandler: {(giphy) in
            print ("saved")
            })
        }
    }
}
