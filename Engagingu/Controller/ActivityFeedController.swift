//
//  ActivityFeedController.swift
//  Engagingu
//
//  Created by Nicholas on 19/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class ActivityFeedController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var activityArr: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
