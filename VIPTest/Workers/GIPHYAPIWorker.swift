//
//  GIPHYAPI.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import Foundation


class GIPHYAPI: GIPHIESStoreProtocol, GIPHIESStoreUtilityProtocol
{
    // MARK: - CRUD operations - Optional error
    
    func fetchGIPHIES(completionHandler: @escaping ([GIPHY], GIPHIESStoreError?) -> Void) {
        return
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping (GIPHY?, GIPHIESStoreError?) -> Void) {
        return;
    }
    
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping (GIPHY?, GIPHIESStoreError?) -> Void) {
        return
    }
    
    // MARK: - CRUD operations - Generic enum result type
    
    func fetchGIPHIES(completionHandler: @escaping GIPHIESStoreFetchGiphiesCompletionHandler) {
        return
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping GIPHIESStoreFetchGiphyCompletionHandler) {
        return
    }
    
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping GIPHIESStoreCreateGiphyCompletionHandler) {
        return
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchGIPHIES(completionHandler: @escaping (() throws -> [GIPHY]) -> Void) {
        return
    }
    
    func fetchGIPHY(id: String, completionHandler: @escaping (() throws -> GIPHY?) -> Void) {
        return
    }
    
    func createGIPHY(giphyToCreate: GIPHY, completionHandler: @escaping (() throws -> GIPHY?) -> Void) {
        return
    }
    
    func fetchGIPIESWITH(strSearch: String, completionHandler: @escaping (() throws -> [GIPHY]?) -> Void){
        let q = strSearch.replacingOccurrences(of: " ", with: "%20")
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://api.giphy.com/v1/gifs/search?%20q=\(q)&api_key=INLDV4yDoGJwV89zKH4oE07KIjmGDIVB")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    //print(httpResponse.debugDescription)
                    if httpResponse?.statusCode == 200 && data != nil {
                        let json = (try? JSONSerialization.jsonObject(with: data!)) as?     [String:Any?]
                    
                        var giphies = [GIPHY]()
                    
                        if (json != nil){
                            giphies = self.parseGIPHYFrom(data: json!)
                        }
                    
                        completionHandler{return giphies }
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    private func parseGIPHYFrom(data: [String:Any?])->[GIPHY]{
        
        let arrayOfDic = (data["data"] as? [[String:Any?]]) ?? [[String:Any?]]()
        var arrayOfGiphies = [GIPHY]()
        for dict in arrayOfDic {
            arrayOfGiphies.append(GIPHYFromDic(dict: dict))
        }
        return arrayOfGiphies;
        
    }
    
}
