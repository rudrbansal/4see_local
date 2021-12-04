//
//  EventDetailViewController.swift
//  4See
//
//  Created by Rudr Bansal on 04/12/21.
//

import UIKit

class EventDetailViewController: UIViewController {

    
    @IBOutlet weak var descriptionImageView: UIImageView!
    @IBOutlet weak var eventDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnActionConfirm(_ sender: UIButton) {
        
    }
    
    @IBAction func btnActionCancel(_ sender: UIButton) {
        
    }
}

extension EventDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailTableViewCell") as! EventDetailTableViewCell
        cell.titleLabel.text = "Dummy text"
        cell.descriptionLabel.text = "Dummy text"
        return cell
    }
}

class EventDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
    
