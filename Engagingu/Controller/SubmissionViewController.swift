//  SubmissionViewController.swift
//  Engagingu

import UIKit
//SubmissionViewContoller display the wefie/drawing done by the team

protocol TableViewCellDelegate: class {
    // Declare a delegate function holding a reference to `SubmissionTableViewCell` instance
    func tableViewCell(_ cell: SubmissionTableViewCell, buttonTapped: UIButton)
}

class SubmissionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var previousUrlDictSize: Int =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
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
        guard let getImagePathsURL = InstanceDAO.serverEndpoints["getAllSubmissionsURL"] else {
            print("Unable to get server endpoint for getImagePathsURL")
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            RestAPIManager.httpGetImageURLs(URLStr: getImagePathsURL + InstanceDAO.team_id + "&trail_instance_id=" + InstanceDAO.trail_instance_id)
            
            print("FINISHED RETRIEVING URLS")
            let urlDict = InstanceDAO.urlDict
            print(urlDict)
            
            if (urlDict.count > 0 && urlDict.count != self.previousUrlDictSize){
                InstanceDAO.submissions.removeAll()
                
                // Iterate through image URLs to get images
                for (_,value) in urlDict{
                    
                    let hotspot = value.hotspot
                    let question = value.question
                    
                    guard let getImageURL = InstanceDAO.serverEndpoints["getSubmission"] else {
                        print("Unable to get server endpoint for getImageURL")
                        return
                    }
                    // Get image
                    RestAPIManager.httpGetImage(URLStr: getImageURL + value.submissionURL, hotspot: hotspot, question: question)
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
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

    }

}

extension SubmissionViewController: UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    //Change to SubmissionPopupViewController when uer tap on the image
    func tableViewCell(_ cell: SubmissionTableViewCell, buttonTapped: UIButton) {
        // You have the cell where the touch event happend, you can get the indexPath like the below
        let indexPath = self.tableView.indexPath(for: cell)
        
        // Debug Prints
        print("In delegate method to performSegue")
        
        // Call `performSegue`
        self.performSegue(withIdentifier: "toPopUpSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toPopUpSegue"){
            let destinationVC = segue.destination as! SubmissionPopUpController
            
            let indexPath = sender as! IndexPath
            
            let media = InstanceDAO.submissions[indexPath.row]
            
            // To put view hierarcy on screen to load view, if not view is not loaded
            _ = destinationVC.view
            
            destinationVC.hotspotLabel.text = media.hotspot
            //destinationVC.questionLabel.text = media.question
            destinationVC.imageView.image = UIImage(data: media.data)
            
        }
    }
    //this method returns the number of rows the tableview should have
    //the number of rows == number of elements in the InstanceDAO.submissions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstanceDAO.submissions.count
    }
    //this method display the submissions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let media = InstanceDAO.submissions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmissionTableViewCell") as! SubmissionTableViewCell
        
        cell.setImage(image: media)
        cell.delegate = self
        return cell
    }
    
}
