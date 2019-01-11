//
//  SubmissionViewController.swift
//  Engagingu
//
//  Created by Nicholas on 4/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class SubmissionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create loading alert
        loadWaitScreen()

        let urlForImages = "http://54.255.245.23:3000/upload/getAllSubmissionURL?team=" + InstanceDAO.team_id + "&trail_instance_id=" + InstanceDAO.trail_instance_id

        RestAPIManager.httpGetImageURLs(URLStr: urlForImages)

        print("FINISHED RETRIEVING URLS")

        let urlDict = InstanceDAO.urlDict

        print(urlDict)

        if (urlDict.count > 0){

            for (key,value) in urlDict{

                let hotspot = value.hotspot
                let question = value.question

                let url = "http://54.255.245.23:3000/upload/getSubmission?url=" + value.submissionURL

//                RestAPIManager.httpGetImage(URLStr: url, hotspot: hotspot, question: question)

            }


        }

        dismiss(animated: false, completion: nil)

        print("Finished Retrieving Images")
        print(InstanceDAO.submissionDict)
    }
    
    func loadWaitScreen() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

    }

}
