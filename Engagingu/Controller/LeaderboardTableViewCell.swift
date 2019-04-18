//  LeaderboardTableViewCell.swift
//  Engagingu
import UIKit
//LeaderboardTableViewCell initialise every row
class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var hotspotsCompletedLabel: UILabel!
    
    func setLabels(teamLabel: String, hotspotLabel: String){
        
        self.teamLabel.text = "TEAM " + teamLabel
        self.hotspotsCompletedLabel.text = hotspotLabel + "/" + String(InstanceDAO.hotspotDict.count) + " COMPLETED"
        
    }
    
}
