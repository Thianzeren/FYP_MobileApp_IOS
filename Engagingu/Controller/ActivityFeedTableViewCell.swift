//
//  ActivityFeedTableViewCell.swift
//  Engagingu
//
//  Created by Nicholas on 19/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class ActivityFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var hotspotLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func setActivity(team: String, hotspot: String, time: String) {
        
        teamLabel.text = "Team " + team + " has completed hotspot:"
        hotspotLabel.text = hotspot
        timeLabel.text = time
        
    }
}
