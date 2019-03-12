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
import UserNotifications

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
        let isLeader = def.bool(forKey: "isLeader")
        let completedList = def.array(forKey: "completedList")
        let startHotspots = def.dictionary(forKey: "startHotspots")
        
        print("UserDefaults team_id: \(team_id)")
        print("UserDefaults trail_instance_id: \(trail_instance_id)")
        print("UserDefaults username: \(username)")
        print("UserDefaults isLeader: \(isLeader)")
        print("UserDefaults completedList: \(completedList)")
        print("UserDefaults startHotspots: \(startHotspots)")
        
        //Retrieve all usernames from DB to check if user has entered before
        guard let retrieveUsernamesURL = InstanceDAO.serverEndpoints["getAllUsers"] else {
            print("Unable to get server endpoint for retrieveUsernamesURL")
            return false
        }
        let usernameDict = RestAPIManager.syncHttpGet(URLStr: retrieveUsernamesURL)
        
        //Check for session
        if let usernameArr = usernameDict["username"] as? [String]{
            
            if !(team_id ?? "").isEmpty && !(trail_instance_id ?? "").isEmpty && (usernameArr.contains(username ?? "")){
                wasLoggedIn = true
            }else {
                print("was not logged in")
            }
        }else{
            print("Username Array was not retrieved from database")
        }
        
        if (wasLoggedIn) {
            
            print("In wasLoggedIn")
            InstanceDAO.team_id = team_id!
            InstanceDAO.trail_instance_id = trail_instance_id!
            InstanceDAO.username = username!
            InstanceDAO.isLeader = isLeader
            InstanceDAO.completedList = completedList as? Array<String> ?? []
            //InstanceDAO.activityArr = activityArr as? Array<Activity> ?? []
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
            
            // Get Word Search words
            guard let wordSearchURL = InstanceDAO.serverEndpoints["getAllWordSearch"] else {
                print("Unable to get server endpoint for wordSearchURL")
                return false
            }
            RestAPIManager.httpGetWordSearch(URLStr: wordSearchURL + InstanceDAO.trail_instance_id)
            
            // Get LeaderMember status
            guard let getLeaderMemberURL = InstanceDAO.serverEndpoints["getAllLeaderMember"] else {
                print("Unable to get server endpoint for getAllLeaderMember")
                return false
            }
            RestAPIManager.httpGetLeaderMemberStatus(URLStr: getLeaderMemberURL)
            
            // Get Activity status
            guard let getActivityFeedURL = InstanceDAO.serverEndpoints["getActivityFeed"] else {
                print("Unable to get server endpoint for getAllActivity")
                return false
            }
            RestAPIManager.httpGetActivityFeed(URLStr: getActivityFeedURL)
            
            // Connect Socket to Server
            SocketHandler.addHandlers()
            SocketHandler.connectSocket()
            
            if let completedList = completedList {
                
                if(completedList.count > 0){
                    InstanceDAO.isFirstTime = false
                    print("AppDelegate isFirstTime: \(InstanceDAO.isFirstTime)")
                }
                
            }
            
            saveCredentialsToSession()
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
            
        }else{
            
            resetDefaults()
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginTrailController")
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
        registerForPushNotifications()
        
        return true

    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        saveCredentialsToSession()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Get Activity status
        guard let getActivityFeedURL = InstanceDAO.serverEndpoints["getActivityFeed"] else {
            print("Unable to get server endpoint for getAllActivity")
            return
        }
        RestAPIManager.httpGetActivityFeed(URLStr: getActivityFeedURL)
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        saveCredentialsToSession()
        
    }
    
    func saveCredentialsToSession(){
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.team_id, forKey: "team_id")
        print("Saved team_id \(InstanceDAO.team_id) to session")
        def.set(InstanceDAO.trail_instance_id, forKey: "trail_instance_id")
        print("Saved trail_instance_id \(InstanceDAO.trail_instance_id) to session")
        def.set(InstanceDAO.username, forKey: "username")
        print("Saved username \(InstanceDAO.username) to session")
        def.set(InstanceDAO.isLeader, forKey: "isLeader")
        print("Saved isLeader \(InstanceDAO.isLeader) to session")
        def.set(InstanceDAO.completedList, forKey: "completedList")
        print("Saved completedList \(InstanceDAO.completedList) to session")
        def.set(InstanceDAO.startHotspots, forKey: "startHotspots")
        print("Saved startHotspots \(InstanceDAO.startHotspots) to session")
        def.synchronize()
        
    }


}

