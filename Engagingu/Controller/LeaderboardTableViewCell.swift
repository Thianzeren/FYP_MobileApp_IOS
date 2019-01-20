//
//  LeaderboardTableViewCell.swift
//  Engagingu
//
//  Created by Nicholas on 19/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var hotspotsCompletedLabel: UILabel!
    
    func setLabels(teamLabel: String, hotspotLabel: String){
        
        self.teamLabel.text = "Team " + teamLabel
        self.hotspotsCompletedLabel.text = hotspotLabel + "/" + String(InstanceDAO.hotspotDict.count) + "COMPLETED"
        
    }
    
}
