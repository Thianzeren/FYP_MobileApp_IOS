//
//  LeaderboardController.swift
//  Engagingu
//
//  Created by Nicholas on 18/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class LeaderboardController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sortedTeamArr: [(String, Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        loadWaitScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let getLeaderboardURL = InstanceDAO.serverEndpoints["getLeaderboard"] else {
            print("Unable to get server endpoint for getLeaderboard")
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            RestAPIManager.httpGetLeaderboard(URLStr: getLeaderboardURL + InstanceDAO.trail_instance_id)
            
            let leaderboardDict = InstanceDAO.leaderboardDict
            
            for(key, value) in leaderboardDict{
                self.sortedTeamArr.append((key, value))
            }
            
            self.sortedTeamArr = self.sortedTeamArr.sorted(by: { $0.1 > $1.1 })
            
            print("SORTED TEAM ARR")
            print(self.sortedTeamArr)
            group.leave()
        }
        
        group.notify(queue: .main){
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.reloadData()
            
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func loadWaitScreen() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension LeaderboardController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstanceDAO.leaderboardDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let teamID = sortedTeamArr[indexPath.row].0
        let teamCompletedHotspots = sortedTeamArr[indexPath.row].1
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell") as! LeaderboardTableViewCell
        
        cell.setLabels(teamLabel: teamID, hotspotLabel: String(teamCompletedHotspots))
        
        //colour for top 3 teams
        if (indexPath.row == 0) {
            cell.backgroundColor = UIColor(red: 255/255.0, green: 215/255.0, blue:0, alpha: 1.0)
        }
        if (indexPath.row == 1){
            cell.backgroundColor = UIColor(red: 192/255.0, green: 192/255.0, blue:192/255.0, alpha: 1.0)
        }
        if (indexPath.row == 2){
            cell.backgroundColor = UIColor(red: 205/255.0, green: 133/255.0, blue:63/255.0, alpha: 1.0)
        }
        return cell
    }
    
}
