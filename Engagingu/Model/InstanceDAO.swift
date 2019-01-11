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
    static var hotspotDict: [String:Hotspot] = [:]
    static var quizDict: [String:HotspotQuiz] = [:]
    static var selfieDict: [String:String] = [:]
    static var urlDict: [String:ImageURL] = [:]
    static var submissionDict: [String:Media] = [:]
    
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

struct Selfie: Decodable{
    let hotspot: String
    let question: String
}

struct ImageURL: Decodable{
    let submissionURL: String
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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

