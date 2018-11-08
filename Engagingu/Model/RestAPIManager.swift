//
//  RestAPIManager.swift
//  Engagingu
//
//  Created by Raylene on 2/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//
//
import Foundation

class APIManager {
    
    let baseURL = "http://54.255.245.23:3000"
    
    func httpPost(jsonData: Data, URLStr: String) -> [String:Any]{
        
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        print(jsonStr)
        print(URLStr)
        var resultDict: [String:Any] = [:]
        if !jsonData.isEmpty {
            
            guard let url = URL(string: URLStr) else {
                print("Error: cannot create URL")
                return [:]
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            //Create and run a URLSession data task
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                do{
                    guard let responseDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        print("Error: no json response received")
                        return
                    }
                    
                    print(responseDict)
                    resultDict = responseDict
                    
                }catch let jsonErr{
                    print ("Error serializing json:" + jsonErr.localizedDescription)
                }
                
            }
            task.resume();
            
        }
        print(resultDict)
        return resultDict
    }
    
}
