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
    
    let baseURL = "http://54.255.245.23:3000"
    
//    func httpPost(jsonData: Data, URLStr: String) -> String{
//
//        var resultJsonStr = ""
//        //let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
//
//        if !jsonData.isEmpty {
//
//            guard let url = URL(string: URLStr) else {
//                print("Error: cannot create URL")
//                return ""
//            }
//
//            var request = URLRequest(url: url)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpMethod = "POST"
//            request.httpBody = jsonData
//
//            //Create and run a URLSession data task
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            let task = session.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil else{
//                    print(error?.localizedDescription ?? "No data")
//                    return
//                }
//
//                do{
//                    guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? String else {
//                        print("Error: no json response received")
//                        return
//                    }
//
//                    print(responseJson)
//                    resultJsonStr = responseJson
//
//                }catch let jsonErr{
//                    print ("Error serializing json:" + jsonErr.localizedDescription)
//                }
//
//            }
//            task.resume();
//
//        }
//        print(resultJsonStr)
//        return resultJsonStr
//    }
//
//    func httpGet(URLStr: String) -> [String:Any]{
//
//        print(URLStr)
//        let jsonUrlString = URLStr
//        var returnJsonStr = ""
//        var returnDict: [String: Any] = [:]
//
//        guard let url = URL(string: jsonUrlString) else {return [:]}
//
//        URLSession.shared.dataTask(with: url){ (data, response, err) in
//
//            guard let data = data else {return}
//
//            let jsonStr = String(data:data, encoding: .utf8)
//
//            do{
//                guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {return}
//
//                //returnJsonStr = jsonObj
//                print("JSON RESPONSE")
//                print(jsonObj)
//                returnDict = jsonObj
//
//            }catch let jsonErr {
//                print ("Error serializing json:" + jsonErr.localizedDescription)
//            }
//
//        }.resume()
//
//        print(returnDict)
//        return returnDict
//    }
    
    
    
}
