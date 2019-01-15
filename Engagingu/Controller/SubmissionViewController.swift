//
//  SubmissionViewController.swift
//  Engagingu
//
//  Created by Nicholas on 4/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class SubmissionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var previousUrlDictSize: Int =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadWaitScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View Did Appear SubmissionViewController")
        
        loadImages()
        
    }
    
    func loadImages(){
        
        // get image urls
        let urlForImages = "http://54.255.245.23:3000/upload/getAllSubmissionURL?team=" + InstanceDAO.team_id + "&trail_instance_id=" + InstanceDAO.trail_instance_id
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            RestAPIManager.httpGetImageURLs(URLStr: urlForImages)
            
            print("FINISHED RETRIEVING URLS")
            let urlDict = InstanceDAO.urlDict
            print(urlDict)
            
            if (urlDict.count > 0 && urlDict.count != self.previousUrlDictSize){
                InstanceDAO.submissions.removeAll()
                
                // Iterate through image URLs to get images
                for (key,value) in urlDict{
                    
                    let hotspot = value.hotspot
                    let question = value.question
                    
                    let url = "http://54.255.245.23:3000/upload/getSubmission?url=" + value.submissionURL
                    print(url)
                    // Get image
                    RestAPIManager.httpGetImage(URLStr: url, hotspot: hotspot, question: question)
                    
                }
                
                self.previousUrlDictSize = urlDict.count
            }
            
            print("Finished Retrieving Images")
            print(InstanceDAO.submissions)
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
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

    }

}

extension SubmissionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstanceDAO.submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = InstanceDAO.submissions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmissionViewCell") as! SubmissionViewCell
        
        cell.setImage(image: image)
        
        return cell
    }
    
}
