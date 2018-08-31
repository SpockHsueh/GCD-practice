//
//  APIClient.swift
//  GCD practice
//
//  Created by Spoke on 2018/8/31.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import Foundation

enum HttpError: Error {
    case requestFailed
    case requestUnsuccessful(statusCode: Int)
    case invaliDate
    case couldNotGetStatusCode
}

class APIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    typealias Name = (String?, Error?) -> Void
    
    func getNameData(completionHandler completion: @escaping Name) {
        
        let nameUrl: URL = URL(string: "https://stations-98a59.firebaseio.com/name.json")!
        
        var request = URLRequest(url: nameUrl)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                

            guard error == nil else {
                completion(nil, HttpError.invaliDate)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, HttpError.requestFailed)
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if let returnData = String(data: data!, encoding: .utf8) {
                        completion(returnData, nil)
                    }
            default:
                completion(nil, HttpError.requestUnsuccessful(statusCode: httpResponse.statusCode))
            }
        }
            
        }
        task.resume()
    }
    
    
    func getAddressData(completionHandler completion: @escaping Name) {
        
        let nameUrl: URL = URL(string: "https://stations-98a59.firebaseio.com/address.json")!
        
        var request = URLRequest(url: nameUrl)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {

            guard error == nil else {
                completion(nil, HttpError.invaliDate)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, HttpError.requestFailed)
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if let returnData = String(data: data!, encoding: .utf8) {
                    completion(returnData, nil)
                }
            default:
                completion(nil, HttpError.requestUnsuccessful(statusCode: httpResponse.statusCode))
            }
        }
        }
        task.resume()
    }
    
    
    func getHeadData(completionHandler completion: @escaping Name) {
        
        let nameUrl: URL = URL(string: "https://stations-98a59.firebaseio.com/head.json")!
        
        var request = URLRequest(url: nameUrl)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
            
            guard error == nil else {
                completion(nil, HttpError.invaliDate)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, HttpError.requestFailed)
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if let returnData = String(data: data!, encoding: .utf8) {
                    completion(returnData, nil)
                }
            default:
                completion(nil, HttpError.requestUnsuccessful(statusCode: httpResponse.statusCode))
            }
        }
        }
        task.resume()
    }
}





