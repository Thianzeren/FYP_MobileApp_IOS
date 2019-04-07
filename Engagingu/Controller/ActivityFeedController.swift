//
//  ActivityFeedController.swift
//  Engagingu
//
//  Created by Nicholas on 19/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit
//ActivityFeed Controller display the real time completed hotspot name and timing taken by all teams
class ActivityFeedController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var team: UILabel!
    var activityArr: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team.text = "You are in Team " + InstanceDAO.team_id
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityArr = InstanceDAO.activityArr
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

}

extension ActivityFeedController: UITableViewDataSource, UITableViewDelegate{
    //this method returns the number of rows the tableview should have
    //the number of rows == number of elements in the activityArraylist
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let activity = activityArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityFeedTableViewCell") as! ActivityFeedTableViewCell
        
        cell.setActivity(team: activity.team, hotspot: activity.hotspot, time: activity.time)
        
        return cell
        
    }
    
    
}
