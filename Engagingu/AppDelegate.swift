//
//  AppDelegate.swift
//  Engagingu
//
//  Created by Raylene on 31/10/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

let googleAPIKey = "AIzaSyAPRQUVZcHXpQ98PvtDDphorQ5kX5ziKTY"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Google Services API Key
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        
        // Variable declaration to be used later
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        var wasLoggedIn = false
        
        // Retrieve variables from session
        let def = UserDefaults.standard
        let team_id = def.string(forKey: "team_id")
        let trail_instance_id = def.string(forKey: "trail_instance_id")
        let username = def.string(forKey: "username")
        let completedList = def.array(forKey: "completedList")
        let startHotspots = def.dictionary(forKey: "startHotspots")
        
        //Retrieve all usernames from DB to check if user has entered before
        guard let retrieveUsernamesURL = InstanceDAO.serverEndpoints["getAllUsers"] else {
            print("Unable to get server endpoint for retrieveUsernamesURL")
            return false
        }
        
        let usernameDict = RestAPIManager.syncHttpGet(URLStr: retrieveUsernamesURL)
        
        //Process Response
        if let usernameArr = usernameDict["username"] as? [String]{
//            print(team_id)
//            print(trail_instance_id)
//            print(username)
//            print(usernameArr.contains(username ?? ""))
            
            if !(team_id ?? "").isEmpty && !(trail_instance_id ?? "").isEmpty && (usernameArr.contains(username ?? "")){
                wasLoggedIn = true
            }
        }else{
            print("Username Array was not retrieve from database")
        }
        
        if (wasLoggedIn) {
            
            print("In wasLoggedIn")
            InstanceDAO.team_id = team_id!
            InstanceDAO.trail_instance_id = trail_instance_id!
            InstanceDAO.completedList = completedList as? Array<String> ?? []
            InstanceDAO.startHotspots = startHotspots as? [String:String] ?? [:]
            
            
            // Get starting hotspots
            guard let startHotspotURL = InstanceDAO.serverEndpoints["getStartingHotspots"] else {
                print("Unable to get server endpoint for getStartingHotspots")
                return false
            }
            RestAPIManager.httpGetStartingHotspots(URLStr: startHotspotURL  + InstanceDAO.trail_instance_id)
            
            // Get hotspot location
            guard let allHotspotURL = InstanceDAO.serverEndpoints["getAllHotspots"] else {
                print("Unable to get server endpoint for getAllHotspots")
                return false
            }
            RestAPIManager.httpGetHotspots(URLStr: allHotspotURL + InstanceDAO.trail_instance_id)
            
            // Get quiz questions
            guard let quizQuestionsURL = InstanceDAO.serverEndpoints["getAllQuizzes"] else {
                print("Unable to get server endpoint for quizQuestionsURL")
                return false
            }
            RestAPIManager.httpGetQuizzes(URLStr: quizQuestionsURL + InstanceDAO.trail_instance_id)
            
            // Get selfie question
            guard let selfieQuestionsURL = InstanceDAO.serverEndpoints["getAllSelfies"] else {
                print("Unable to get server endpoint for selfieQuestionsURL")
                return false
            }
            RestAPIManager.httpGetSelfies(URLStr: selfieQuestionsURL  + InstanceDAO.trail_instance_id)
            
            // Get Anagram Questions
            guard let anagramURL = InstanceDAO.serverEndpoints["getAllAnagrams"] else {
                print("Unable to get server endpoint for anagramURL")
                return false
            }
            RestAPIManager.httpGetAnagram(URLStr: anagramURL + InstanceDAO.trail_instance_id)
            
            // Get Drag And Drop Questions
            guard let dragAndDropURL = InstanceDAO.serverEndpoints["getAllDragAndDrops"] else {
                print("Unable to get server endpoint for dragAndDropURL")
                return false
            }
            RestAPIManager.httpGetDragAndDrop(URLStr: dragAndDropURL + InstanceDAO.trail_instance_id)
            
            // Get Drawing Questions
            guard let drawingURL = InstanceDAO.serverEndpoints["getAllDrawings"] else {
                print("Unable to get server endpoint for drawingURL")
                return false
            }
            RestAPIManager.httpGetDrawing(URLStr: drawingURL + InstanceDAO.trail_instance_id)
            
            // Get LeaderMember status
            guard let getLeaderMemberURL = InstanceDAO.serverEndpoints["getAllLeaderMember"] else {
                print("Unable to get server endpoint for getAllLeaderMember")
                return false
            }
            RestAPIManager.httpGetLeaderMemberStatus(URLStr: getLeaderMemberURL)
            
            // Connect Socket to Server
            SocketHandler.addHandlers()
            SocketHandler.connectSocket()
            
            if let completedList = completedList {
                
                if(completedList.count > 0){
                    InstanceDAO.isFirstTime = false
                }
            }
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }else{
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginTrailController")
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.completedList, forKey: "completedList")
        def.set(InstanceDAO.startHotspots, forKey: "startHotspots")
        def.synchronize()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.completedList, forKey: "completedList")
        def.set(InstanceDAO.startHotspots, forKey: "startHotspots")
        def.synchronize()
        
    }


}

