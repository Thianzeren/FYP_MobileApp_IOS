//
//  Structs.swift
//  Engagingu
//
//  Created by Nicholas on 11/3/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import Foundation
import UIKit

// Stores all structs used in the application

// Hotspot struct stores all information of hotspot
struct Hotspot: Decodable{
    
    let coordinates: [String]
    let name: String
    let narrative: String
    
    init(coordinates: [String], name: String, narrative: String) {
        self.coordinates = coordinates
        self.name = name
        self.narrative = narrative
    }
}

// User struct stores all information of user
struct User: Decodable{
    
    let username: String
    let team: Int
    let isLeader: Int
}

// HotspotQuiz stores all information regarding the quiz
struct HotspotQuiz: Decodable{
    
    let hotspot: String
    let quiz: [Quiz]
    
}

// Quiz stores the question, answers and options, is used in struct HotspotQuiz
struct Quiz: Decodable{
    let quiz_question: String
    let quiz_answer: Int
    let quiz_options: [String]
}

// Selfie stores hotspot and selfie question
struct Selfie: Decodable{
    let hotspot: String
    let question: String
}

// ImageURL stores the image's path and also the corresponding hotspot and question
struct ImageURL: Decodable{
    let submissionURL: String
    let hotspot: String
    let question: String
}

// TeamStartHotspot stores starting hotspot allocated to the team
struct TeamStartHotspot: Decodable{
    let team: Int
    let startingHotspot: String
}

// Leaderboard stores team and number of hotspots completed
struct Leaderboard: Decodable{
    let team: Int
    let hotspots_completed: Int
}

// Activity stores all activity information for activity feed
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

// Drag And Drop stores all drag and drop information
struct DragAndDrop: Decodable{
    
    let hotspot: String
    let question: String
    let drag_and_drop: [QnA]
    
}

// QnA stores individual drag and drop question and answer
struct QnA: Decodable{
    
    let drag_and_drop_question: String
    let drag_and_drop_answer: String
    
}

// Anagram stores the hotspot name and anagram word
struct Anagram: Decodable{
    
    let hotspot: String
    let anagram: String
}

// WordSearch stores the hotspot name and the words that are meant to be found
struct WordSearch: Decodable{
    
    let hotspot: String
    let words: [String]
    
}

// DrawingQns stores the hotspot name and the question for the question mission
struct DrawingQns: Decodable {
    
    let hotspot: String
    let question: String
}

// Outcome stores the question, user's answer and expected answer
struct Outcome {
    
    let question: String
    let userAnswer: String
    let expectedAnswer: String
    
    init(question: String, userAnswer: String, expectedAnswer: String){
        self.question = question
        self.userAnswer = userAnswer
        self.expectedAnswer = expectedAnswer
    }
    
}

// Media stores information regarding the media iamges
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
        
        self.key = key
        self.hotspot = hotspot
        self.question = question
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        self.data = data
        
    }
    
}

