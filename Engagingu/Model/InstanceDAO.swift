//
//  InstanceDAO.swift
//  Engagingu
//
//  Created by Nicholas on 6/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import Foundation
    
struct InstanceDAO {
    
    static var team_id: String = "0"
    static var trail_instance_id: String = "defaultId"
    static var username: String = "defaultName"
    static var completedList: Array<String> = Array()
    static var hotspotDict: [String:Hotspot] = [:]
    static var quizDict: [String:HotspotQuiz] = [:]
    static var selfieDict: [String:String] = [:]
    
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
