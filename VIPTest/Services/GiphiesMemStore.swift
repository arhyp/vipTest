//
//  GiphiesMemStore.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import Foundation

class GiphiesMemStore: GIPHIESStoreProtocol, GIPHIESStoreUtilityProtocol
{
    
    

    // MARK: - Data
    static var giphies = [GIPHY]()
    
    // MARK: - CRUD operations - Optional error
    
    func fetchGIPHIES(completionHandler: @escaping ([GIPHY], GIPHIESStoreError?) -> Void)
    {
        completionHandler(type(of: self).giphies, nil)
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping (GIPHY?, GIPHIESStoreError?) -> Void)
    {
        if let index = indexOfGiphyWithID(id: id) {
            let giphy = type(of: self).giphies[index]
            completionHandler(giphy, nil)
        } else {
            completionHandler(nil, GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)"))
        }
    }
    
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping (GIPHY?, GIPHIESStoreError?) -> Void)
    {
        var giphy = giphyToCreate
        generateGIPHYID(giphy: &giphy)
        type(of: self).giphies.append(giphy)
        completionHandler(giphy, nil)
    }
    
  
    
    // MARK: - CRUD operations - Generic enum result type
    
    func fetchGIPHIES(completionHandler: @escaping GIPHIESStoreFetchGiphiesCompletionHandler)
    {
        completionHandler(GIPHIESStoreResult.Success(result: type(of: self).giphies))
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping GIPHIESStoreFetchGiphyCompletionHandler)
    {
        let giphy = type(of: self).giphies.filter { (giphy: GIPHY) -> Bool in
            return giphy.id == id
            }.first
        if let giphy = giphy {
            completionHandler(GIPHIESStoreResult.Success(result: giphy))
        } else {
            completionHandler(GIPHIESStoreResult.Failure(error: GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)")))
        }
    }
    
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping GIPHIESStoreCreateGiphyCompletionHandler)
    {
        var giphy = giphyToCreate
        generateGIPHYID(giphy: &giphy)
   
        type(of: self).giphies.append(giphy)
        completionHandler(GIPHIESStoreResult.Success(result: giphy))
    }
    
  
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchGIPHIES(completionHandler: @escaping (() throws -> [GIPHY]) -> Void)
    {
        completionHandler { return type(of: self).giphies }
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping (() throws -> GIPHY?) -> Void)
    {
        if let index = indexOfGiphyWithID(id: id) {
            completionHandler { return type(of: self).giphies[index] }
        } else {
            completionHandler { throw GIPHIESStoreError.CannotFetch("Cannot fetch giphy with id \(id)") }
        }
    }
    
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping (() throws -> GIPHY?) -> Void)
    {
        let giphy = giphyToCreate
        let oldGiphy = type(of: self).giphies.filter({ (oGiphy) -> Bool in
            if (oGiphy.id == giphy.id){
                return true;
            }else {return false}
        }).first
        
        if oldGiphy == nil {
            type(of: self).giphies.append(giphy)
        }
        completionHandler { return giphy }
    }
    

    
    // MARK: - Convenience methods
    
    private func indexOfGiphyWithID(id: String?) -> Int?
    {
        return type(of: self).giphies.index { return $0.id == id }
    }
}
