//  ActivityFeedTableViewCell.swift
//  Engagingu

import UIKit
//ActivityFeedTableViewCell initialises every row
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
