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
    
    static var serverIP: String = "http://54.255.245.23:3000"
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
        "getAllUsers" : serverIP + "/user/retrieveAllUsers",
        "getAllLeaderMember" : serverIP + "/user/retrieveAllUser",
        "getAllDrawings" : serverIP + "/upload/getDrawingQuestion?trail_instance_id="
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

struct Hotspot: Decodable{ //create a Hotspot class use for the jsondecoder
    
    let coordinates: [String]
    let name: String
    let narrative: String
    
    init(coordinates: [String], name: String, narrative: String) {
        self.coordinates = coordinates
        self.name = name
        self.narrative = narrative
    }
}

struct User: Decodable{
    
    let username: String
    let team: Int
    let isLeader: Int
}
struct HotspotQuiz: Decodable{
    
    let hotspot: String
    let quiz: [Quiz]
    
}

struct Quiz: Decodable{
    let quiz_question: String
    let quiz_answer: Int
    let quiz_options: [String]
}

struct Selfie: Decodable{
    let hotspot: String
    let question: String
}

struct ImageURL: Decodable{
    let submissionURL: String
    let hotspot: String
    let question: String
}

struct TeamStartHotspot: Decodable{
    let team: Int
    let startingHotspot: String
}

struct Leaderboard: Decodable{
    let team: Int
    let hotspots_completed: Int
}

struct Activity: Decodable{
    let team: String
    let hotspot: String
    let time: String
    
    init(team: String, hotspot: String, time: String){
        self.team = team
        self.hotspot = hotspot
        self.time = time
    }
}

struct DragAndDrop: Decodable{
    
    let hotspot: String
    let question: String
    let drag_and_drop: [QnA]

}

struct QnA: Decodable{
    
    let drag_and_drop_question: String
    let drag_and_drop_answer: String
    
}

struct Anagram: Decodable{
    
    let hotspot: String
    let anagram: String
}

struct DrawingQns: Decodable {
    
    let hotspot: String
    let question: String
}

struct Media{
    let key: String
    let hotspot: String
    let question: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String, hotspot: String, question: String) {
        
        self.mimeType = "image/png"
        
        // Get current time stamp
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        self.filename = "wefieTeam\(InstanceDAO.team_id + dateString).jpeg"
        
        print(filename)
        
        self.key = key
        self.hotspot = hotspot
        self.question = question
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        self.data = data
        
    }
    
}

