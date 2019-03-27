//
//  RestAPIManager.swift
//  Engagingu
//
//  Created by Raylene on 2/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//
//
import UIKit
import Foundation

class RestAPIManager {
    
    static func syncHttpGet(URLStr: String) -> [String:Any]{
        
        var result: [String:Any] = [:]
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            print("URL cannot be generated ffrom URLStr")
            semaphore.signal()
            return [:]
        }
        
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("syncHttpGet Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                semaphore.signal()
            }
            
            guard let data = data else {
                print("No data received from GET request")
                semaphore.signal()
                return
            }
            
            //Debug Print
//            let jsonStr = String(data:data, encoding: .utf8)
//            print("Json Response")
//            print(jsonStr)
            
            do{
                guard let resultDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                    semaphore.signal()
                    return
                }
                
                //                print("Result Dict:")
                //                print(resultDict)
                result = resultDict
                
                semaphore.signal()
            }catch let jsonErr {
                print ("Error serializing json:" + jsonErr.localizedDescription)
                semaphore.signal()
            }
            
            }.resume()
        
        semaphore.wait()
        
        //        print("RESULT:")
        //        print(result)
        
        return result
    }
    
    static func syncHttpPost(jsonData: Data, URLStr: String) -> [String:Any]{
        
        let semaphore = DispatchSemaphore(value: 0)
        var result: [String:Any] = [:]
        //let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"

        if !jsonData.isEmpty{

            guard let url = URL(string: URLStr) else {
                print("Error: cannot create URL")
                semaphore.signal()
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
                
                if let urlResponse = response as? HTTPURLResponse {
                    let status = urlResponse.statusCode
                    result["response"] = status
                    print("syncHttpPost Response: \(status)")
                }
                
                if let error = error {
                    print("DataTask error: " + error.localizedDescription + "\n")
                    semaphore.signal()
                }
                
                guard let data = data, error == nil else{
                    print(error?.localizedDescription ?? "No data")
                    semaphore.signal()
                    return
                }

                do{
                    guard let responseDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                        print("Error: no json response received")
                        semaphore.signal()
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
            task.resume()
            
            semaphore.wait()

        }
        
        print(result)
        return result
    }
    
    static func asyncHttpGet(URLStr: String) -> [String:Any]{
        
        var result: [String:Any] = [:]
        
        guard let url = URL(string: URLStr) else {
            print("URL cannot be generated ffrom URLStr")
            return [:]
        }
        
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("asyncHttpGet Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
                print("No data received from GET request")
                return
            }
            
            //Debug Print
//            let jsonStr = String(data:data, encoding: .utf8)
//            print("Json Response")
//            print(jsonStr)
            
            do{
                guard let resultDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                    return
                }
                
                //                print("Result Dict:")
                //                print(resultDict)
                result = resultDict
                
            }catch let jsonErr {
                print ("Error serializing json:" + jsonErr.localizedDescription)
            }
            
            }.resume()
        
        //        print("RESULT:")
        //        print(result)
        
        return result
    }
    
    static func asyncHttpPost(jsonData: Data, URLStr: String) -> [String:Any]{
        
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
                
                
                if let urlResponse = response as? HTTPURLResponse {
                    let status = urlResponse.statusCode
                    print("asyncHttpPost Response: \(status)")
                }
                
                if let error = error {
                    print("DataTask error: " + error.localizedDescription + "\n")
                }
                
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
                    
                }catch let jsonErr{
                    print ("Error serializing json:" + jsonErr.localizedDescription)
                }
                
            }
            task.resume();
            
        }
        
        print(result)
        return result
    }
    
    static func httpGetHotspots(URLStr: String){
        
//        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetHotspots Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
//                semaphore.signal()
                return
            }
            
            do {
                let hotspots = try
                    JSONDecoder().decode([Hotspot].self, from: data)
                
                for hotspot in hotspots{
                    InstanceDAO.hotspotDict[hotspot.name] = hotspot
                }
                
//                print("HOTSPOT")
//                print(InstanceDAO.hotspotDict)
                
//                semaphore.signal()
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
//                semaphore.signal()
            }
            
            
        }.resume()
        
//        semaphore.wait()
        
    }
    
    static func httpGetStartingHotspots(URLStr: String){
        
        guard let url = URL(string: URLStr) else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetStartingHotspots Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else { return }
            
            do {
                let teamStartHotspots = try
                    JSONDecoder().decode([TeamStartHotspot].self, from: data)
                
                for teamStartHotspot in teamStartHotspots{
                    InstanceDAO.startHotspots[String(teamStartHotspot.team)] = teamStartHotspot.startingHotspot
                }
                
                print("TEAM START HOTSPOT")
                print(InstanceDAO.startHotspots)
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
        
    }
    
    static func httpGetQuizzes(URLStr: String){
        
        guard let url = URL(string: URLStr) else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetQuizzes Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else { return }
            
            do {
                let quizzes = try
                    JSONDecoder().decode([HotspotQuiz].self, from: data)
                
                for quiz in quizzes{
                    InstanceDAO.quizDict[quiz.hotspot] = quiz
                }
                
                print("QUIZZES")
                print(InstanceDAO.quizDict)
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
        
    }
    
    static func httpGetSelfies(URLStr: String){
        
        guard let url = URL(string: URLStr) else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetSelfies Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else { return }
            
            do {
                let selfies = try
                    JSONDecoder().decode([Selfie].self, from: data)
                
                for selfie in selfies{
                    InstanceDAO.selfieDict[selfie.hotspot] = selfie.question
                }
                
                print("SELFIES")
                print(InstanceDAO.selfieDict)
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
        
    }
    
    static func httpGetImageURLs(URLStr: String){
        
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else { return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetImageURLs Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                semaphore.signal()
            }
            
            guard let data = data else {
                semaphore.signal
                return
            }
            
            do {
                let urls = try
                    JSONDecoder().decode([ImageURL].self, from: data)
                
                for url in urls{
                    InstanceDAO.urlDict[url.hotspot] = url
                }
                
                print("IMAGEURLS")
                print(InstanceDAO.urlDict)
                semaphore.signal()
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
                semaphore.signal()
            }
            
            
        }.resume()
        
        semaphore.wait()
        
    }
    
    static func httpGetImage(URLStr: String, hotspot: String, question: String){
        
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            print("URL CANNOT BE CREATED")
            return
            
        }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetImage Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                semaphore.signal()
            }
            
            guard let data = data else {
                print("NO DATA RETRIEVED")
                semaphore.signal()
                return
            }

            InstanceDAO.submissions.append(Media(withImage: UIImage(data: data)!, forKey: "image", hotspot: hotspot, question: question)!)
            
            semaphore.signal()
            
            
        }.resume()
        
        semaphore.wait()
        
    }

    static func httpGetLeaderboard(URLStr: String){
        
        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
           semaphore.signal()
            return
        }

        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetLeaderboard Response: \(response)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                semaphore.signal()
            }
            
            guard let data = data else {
               semaphore.signal()
                return
            }

            do {
                let leaderboards = try
                    JSONDecoder().decode([Leaderboard].self, from: data)

                for leaderboard in leaderboards{
                    InstanceDAO.leaderboardDict[String(leaderboard.team)] = leaderboard.hotspots_completed
                }

                print("LEADERBOARD")
                print(InstanceDAO.leaderboardDict)
                
                semaphore.signal()

            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }


        }.resume()
        
        semaphore.wait()

    }
    
    static func httpGetAnagram(URLStr: String){
        
//        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
//            semaphore.signal()
            print("URL cannot be created")
            return
        }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetAnagram Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
//                semaphore.signal()
                print("No data available")
                return
            }
            
            do {
                let anagrams = try
                    JSONDecoder().decode([Anagram].self, from: data)
                
                for anagram in anagrams{
                    InstanceDAO.anagramDict[anagram.hotspot] = anagram.anagram
                }
                
                print("ANAGRAM")
                print(InstanceDAO.anagramDict)
                
//                semaphore.signal()
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
        }.resume()
        
//        semaphore.wait()
        
    }
    
    static func httpGetDragAndDrop(URLStr: String){
        
//        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
//            semaphore.signal()
            print("URL cannot be created")
            return
        }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetDragAndDrop Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
//                semaphore.signal()
                print("No data available")
                return
            }
            
            do {
                let dragAndDrops = try
                    JSONDecoder().decode([DragAndDrop].self, from: data)
                
                for dragAndDrop in dragAndDrops{
                    InstanceDAO.dragAndDropDict[dragAndDrop.hotspot] = dragAndDrop
                }
                
                print("DRAG AND DROP")
                print(InstanceDAO.dragAndDropDict)
                
//                semaphore.signal()
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
//        semaphore.wait()
        
    }
    
    static func httpGetDrawing(URLStr: String){
        
        //        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            //            semaphore.signal()
            print("URL cannot be created")
            return
        }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetDrawing Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
                //                semaphore.signal()
                print("No data available")
                return
            }
            
            do {
                let drawings = try
                    JSONDecoder().decode([DrawingQns].self, from: data)
                
                for drawing in drawings{
                    InstanceDAO.drawingDict[drawing.hotspot] = drawing.question
                }
                
                print("DRAWING")
                print(InstanceDAO.drawingDict)
                
                //                semaphore.signal()
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
        //        semaphore.wait()
        
    }
    
    static func httpGetWordSearch(URLStr: String){
        
        //        let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            //            semaphore.signal()
            print("URL cannot be created")
            return
        }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetWordSearch Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
                //                semaphore.signal()
                print("No data available")
                return
            }
            
            do {
                let wordSearches = try
                    JSONDecoder().decode([WordSearch].self, from: data)
                
                for wordSearch in wordSearches{
                    InstanceDAO.wordSearchDict[wordSearch.hotspot] = wordSearch
                }
                
                print("WORD SEARCH")
                print(InstanceDAO.wordSearchDict)
                
                //                semaphore.signal()
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
        //        semaphore.wait()
        
    }
    
    static func httpGetLeaderMemberStatus(URLStr: String){
        
        //let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            //semaphore.signal()
            return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetLeaderMemberStatus Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
                //semaphore.signal()
                return }
            
            do {
                let users = try
                    JSONDecoder().decode([User].self, from: data)
                
                for user in users{
                    InstanceDAO.userDict[user.username] = user
                }
                
                print("USERS")
                print(InstanceDAO.userDict)
                
                //semaphore.signal()
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
        //semaphore.wait()
    }
    
    static func httpGetActivityFeed(URLStr: String){
        
        //let semaphore = DispatchSemaphore(value: 0)
        
        guard let url = URL(string: URLStr) else {
            //semaphore.signal()
            return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            //check error
            //check response status ok
            
            if let urlResponse = response as? HTTPURLResponse {
                let status = urlResponse.statusCode
                print("httpGetActivityFeed Response: \(status)")
            }
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            }
            
            guard let data = data else {
                //semaphore.signal()
                return }
            
            do {
                let activities = try
                    JSONDecoder().decode([Activity].self, from: data)
                
                InstanceDAO.activityArr.removeAll()
                
                if InstanceDAO.isLeader == false {
                    
                    InstanceDAO.completedList.removeAll()
                    
                    for activity in activities{
                        InstanceDAO.activityArr.append(activity)
                        
                        let team = activity.team
                        let hotspot = activity.hotspot
                        
                        if team == InstanceDAO.team_id {
                            
                            if !InstanceDAO.completedList.contains(hotspot){
                                InstanceDAO.completedList.append(hotspot)
                            }
                            
                        }
                    }
                }else {
                    
                    for activity in activities{
                        InstanceDAO.activityArr.append(activity)
                    }
                    
                }
                
                print("ACTIVITY")
                print(InstanceDAO.activityArr)
                
                // Populate completed hotspots
                
                
                //semaphore.signal()
            } catch let jsonErr{
                print("Error serializing json:", jsonErr)
            }
            
            
            }.resume()
        
        //semaphore.wait()
    }
}
