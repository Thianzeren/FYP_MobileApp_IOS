//
//  Structs.swift
//  Engagingu
//
//  Created by Nicholas on 11/3/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import Foundation
import UIKit


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

struct WordSearch: Decodable{
    
    let hotspot: String
    let words: [String]
   // let title: String
    
}

struct DrawingQns: Decodable {
    
    let hotspot: String
    let question: String
}

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

