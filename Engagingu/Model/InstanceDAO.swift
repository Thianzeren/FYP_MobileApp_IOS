//
//  InstanceDAO.swift
//  Engagingu
//
//  Created by Nicholas on 6/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import GooglePlaces

// Stores all necessary data of user and trail

struct InstanceDAO {
    
    static var team_id: String = "0"
    static var trail_instance_id: String = "defaultId"
    static var username: String = "defaultName"
    static var completedList: Array<String> = Array()
    
    // AWS Server IP
    // (HTTP)
    static var socketServerIP: String = "http://13.228.173.165:3000"
    // HTTPS
    static var serverIP: String = "https:amazingtrail.ml/api"
    
    static var serverEndpoints: [String:String] = [
        "getInstanceId" : serverIP + "/getInstance",
        "registerUser" : serverIP + "/user/register",
        "getStartingHotspots" : serverIP + "/team/startingHotspot?trail_instance_id=",
        "getAllHotspots" : serverIP + "/location/getAllHotspots?trail_instance_id=",
        "getAllQuizzes" : serverIP + "/quiz/getQuizzes?trail_instance_id=",
        "getAllSelfies" : serverIP + "/upload/getSubmissionQuestion?trail_instance_id=",
        "getAllAnagrams" : serverIP + "/anagram/getAnagrams?trail_instance_id=",
        "getAllDragAndDrops" : serverIP + "/draganddrop/getDragAndDrop?trail_instance_id=",
        "uploadSubmission" : serverIP + "/upload/uploadSubmission",
        "updateScore" : serverIP + "/team/updateScore",
        "getAllSubmissionsURL" : serverIP + "/upload/getAllSubmissionURL?team=",
        "getSubmission" : serverIP + "/upload/getSubmission?url=",
        "getLeaderboard" : serverIP + "/team/hotspotStatus?trail_instance_id=",
        "getActivityFeed" : serverIP + "/team/activityFeed",
        "getAllUsers" : serverIP + "/user/retrieveAllUsers",
        "getAllLeaderMember" : serverIP + "/user/retrieveAllUser",
        "getAllDrawings" : serverIP + "/upload/getDrawingQuestion?trail_instance_id=",
        "getAllWordSearch" : serverIP + "/wordsearch/getWordSearchWords?trail_instance_id=",
        "updateLocation" : serverIP + "/team/teamLocation"
    ]
    
    // For Submissions
    static var submissions: [Media] = []
    
    // Array of activity objects
    static var activityArr: [Activity] = []
    
    // Key: Hotspot name, Value: Hotspot object
    static var hotspotDict: [String:Hotspot] = [:]
    
    // Key: Hotspot name, Value: HotspotQuiz object
    static var quizDict: [String:HotspotQuiz] = [:]
    
    // Key: Hotspot name, Value: Selfie Question
    static var selfieDict: [String:String] = [:]
    
    // Key: Hotspot name, Value: Anagram Word
    static var anagramDict: [String:String] = [:]
    
    // Key: Hotspot name, Value: DragAndDrop object
    static var dragAndDropDict: [String:DragAndDrop] = [:]
    
    // Key: hotspot name, Value: Drawing object
    static var drawingDict: [String:String] = [:]
    
    // Key: Hotspot name, Value: ImageURL Object
    static var urlDict: [String:ImageURL] = [:]
    
    // Key: Hotspot name, Value: Array of String (Words)
    static var wordSearchDict: [String:WordSearch] = [:]
    
    // Key: Team number, Value: hotspot name
    static var startHotspots: [String:String] = [:]
    
    // Key: Team number, Value: no. of hotspots completed
    static var leaderboardDict: [String:Int] = [:]
    
    // Key: Username, Value: user object
    static var userDict: [String:User] = [:]
    
    // Check if is first time entering
    static var isFirstTime: Bool = true
    
    // Check if is leader
    static var isLeader: Bool = false
    
    // Check if can start trail
    static var hasStartedTrail: Bool = false
    
    // Resets InstanceDAO back to default
    static func resetInstance() {
        
        team_id = "0"
        trail_instance_id = "defaultId"
        username = "defaultName"
        completedList.removeAll()
        
        submissions.removeAll()
        activityArr.removeAll()
        
        hotspotDict.removeAll()
        quizDict.removeAll()
        selfieDict.removeAll()
        anagramDict.removeAll()
        dragAndDropDict.removeAll()
        drawingDict.removeAll()
        urlDict.removeAll()
        wordSearchDict.removeAll()
        startHotspots.removeAll()
        leaderboardDict.removeAll()
        userDict.removeAll()
        
        isFirstTime = true
        isLeader = false
        hasStartedTrail = false
        
    }
    
}
