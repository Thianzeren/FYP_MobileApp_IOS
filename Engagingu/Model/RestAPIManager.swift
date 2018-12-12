//
//  RestAPIManager.swift
//  Engagingu
//
//  Created by Raylene on 2/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//
//
import Foundation

class RestAPIManager {
    
    static func syncHttpPost(jsonData: Data, URLStr: String) -> [String:Any]{
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: [String:Any] = [:]
        //let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"

        if !jsonData.isEmpty{

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
                    guard let responseDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                        print("Error: no json response received")
                        return
                    }

                    print(responseDict)
                    result = responseDict
                    semaphore.signal()
                    
                }catch let jsonErr{
                    print ("Error serializing json:" + jsonErr.localizedDescription)
                    semaphore.signal()
                }

            }
            task.resume();
            semaphore.wait();

        }
        
        print(result)
        return result
    }

    static func syncHttpGet(URLStr: String) -> [String:Any]{
        
        var result: [String:Any] = [:]
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            print("URL cannot be generated ffrom URLStr")
            return [:]
        }

        URLSession.shared.dataTask(with: url){ (data, response, err) in

            guard let data = data else {
                print("No data received from GET request")
                return
            }

            //Debug Print
            let jsonStr = String(data:data, encoding: .utf8)
            print("Json Response")
            print(jsonStr)
            
            do{
                guard let resultDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                    return
                }
                
//                print("Result Dict:")
//                print(resultDict)
                result = resultDict
                
                semaphore.signal()
            }catch let jsonErr {
                print ("Error serializing json:" + jsonErr.localizedDescription)
            }
            
        }.resume()
        
        semaphore.wait()
        
//        print("RESULT:")
//        print(result)
        
        return result
    }
    
    
    
}
