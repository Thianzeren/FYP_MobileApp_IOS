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
}

struct Hotspot: Decodable{ //create a Hotspot class use for the jsondecoder
    
    let coordinates: [String]
    let name: String
    let narrative: String
}
