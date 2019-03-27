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
    
struct InstanceDAO {
    
    static var team_id: String = "0"
    static var trail_instance_id: String = "defaultId"
    static var username: String = "defaultName"
    static var completedList: Array<String> = Array()
    
    static var serverIP: String = "http://13.229.115.32:3000"
//    static var serverIP: String = "http://54.255.245.23:3000"
    
    static var serverEndpoints: [String:String] = [
        "getInstanceId" : serverIP + "/getInstance",
        "registerUser" : serverIP + "/user/register",
        "getStartingHotspots" : serverIP + "/team/startingHotspot?trail_instance_id=",
        "getAllHotspots" : serverIP + "/hotspot/getAllHotspots?trail_instance_id=",
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
    
    // For Submissions
    static var submissions: [Media] = []
    
    // Key: Team number, Value: hotspot name
    static var startHotspots: [String:String] = [:]
    
    // Key: Team number, Value: no. of hotspots completed
    static var leaderboardDict: [String:Int] = [:]
    
    // Key: Username, Value: user object
    static var userDict: [String:User] = [:]
    
    // Array of activity objects
    static var activityArr: [Activity] = []
    
    // Check if is first time entering
    static var isFirstTime: Bool = true
    
    // Check if is leader
    static var isLeader: Bool = false
    
    // Check if can start trail
    static var hasStartedTrail: Bool = false
    
}
