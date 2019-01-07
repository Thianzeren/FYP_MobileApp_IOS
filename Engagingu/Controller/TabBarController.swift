//
//  TabBarController.swift
//  Engagingu
//
//  Created by Nicholas on 12/12/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get hotspot location
        var jsonUrlString = "http://54.255.245.23:3000/hotspot/getAllHotspots?trail_instance_id=" + InstanceDAO.trail_instance_id
        RestAPIManager.httpGetHotspots(URLStr: jsonUrlString)
        print("HOTSPOT LOCATIONS")
        print(InstanceDAO.hotspotDict)
        
        // Get hotspot quizzes
        jsonUrlString = "http://54.255.245.23:3000/quiz/getQuizzes?trail_instance_id=" + InstanceDAO.trail_instance_id
        RestAPIManager.httpGetQuizzes(URLStr: jsonUrlString)
        print("QUIZZES")
        print(InstanceDAO.quizDict)
        
        // Get hotspot selfies
        jsonUrlString = "http://54.255.245.23:3000/upload/getSubmissionQuestion?trail_instance_id=" + InstanceDAO.trail_instance_id
        RestAPIManager.httpGetSelfies(URLStr: jsonUrlString)
        print("HOTSPOTS")
        print(InstanceDAO.selfieDict)
        
        self.selectedIndex = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
