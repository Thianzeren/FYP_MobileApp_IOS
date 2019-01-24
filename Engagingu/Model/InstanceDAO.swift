//
//  InstanceDAO.swift
//  Engagingu
//
//  Created by Nicholas on 6/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit
import Foundation
    
struct InstanceDAO {
    
    static var team_id: String = "0"
    static var trail_instance_id: String = "defaultId"
    static var username: String = "defaultName"
    static var completedList: Array<String> = Array()
    
    // Key: Hotspot name, Value: Hotspot object
    static var hotspotDict: [String:Hotspot] = [:]
    
    // Key: Hotspot name, Value: HotspotQuiz object
    static var quizDict: [String:HotspotQuiz] = [:]
    
    // Key: Hotspot name, Value: Selfie Question
    static var selfieDict: [String:String] = [:]
    
    // Key: Hotspot name, Value: Anagram Word
    static var anagramDict: [String:String] = [:]
    
    // Key: Hotspot name, Value: ImageURL Object
    static var urlDict: [String:ImageURL] = [:]
    static var submissions: [Media] = []
    
    // Key: Team number, Value: hotspot name
    static var startHotspots: [String:String] = [:]
    
    // Key: Team number, Value: no. of hotspots completed
    static var leaderboardDict: [String:Int] = [:]
    
    // Array of activity objects
    static var activityArr: [Activity] = []
    
    // Check if is first time entering
    static var isFirstTime: Bool = true
}

struct Hotspot: Decodable{ //create a Hotspot class use for the jsondecoder
    
    let coordinates: [String]
    let name: String
    let narrative: String
}

struct HotspotQuiz: Decodable{
    
    let hotspot: String
    
    struct Quiz: Decodable{
        let quiz_question: String
        let quiz_answer: Int
        let quiz_options: [String]
    }
    
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

struct Anagram: Decodable{
    
    let hotspot: String
    let anagram: String
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
        
        self.filename = "selfieTeam\(InstanceDAO.team_id + dateString).jpeg"
        
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

