//
//  SubmissionViewController.swift
//  Engagingu
//
//  Created by Nicholas on 4/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
    // Declare a delegate function holding a reference to `UICollectionViewCell` instance
    func tableViewCell(_ cell: SubmissionViewCell, buttonTapped: UIButton)
}

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

extension SubmissionViewController: UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    func tableViewCell(_ cell: SubmissionViewCell, buttonTapped: UIButton) {
        // You have the cell where the touch event happend, you can get the indexPath like the below
        let indexPath = self.tableView.indexPath(for: cell)
        // Call `performSegue`
        self.performSegue(withIdentifier: "toPopUpSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toPopUpSegue"){
            var destinationVC = segue.destination as! SubmissionPopUpController
            
            let indexPath = sender as! IndexPath
            
            let media = InstanceDAO.submissions[indexPath.row]
            
            // To put view hierarcy on screen to load view, if not view is not loaded
            let destinationView = destinationVC.view
            
            destinationVC.hotspotLabel.text = media.hotspot
            destinationVC.questionLabel.text = media.question
            destinationVC.imageView.image = UIImage(data: media.data)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstanceDAO.submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let media = InstanceDAO.submissions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmissionViewCell") as! SubmissionViewCell
        
        cell.setImage(image: media)
        cell.delegate = self
        return cell
    }
    
}
