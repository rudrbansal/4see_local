//
//  NotificationsViewController.swift
//  4See
//
//  Created by Rudr Bansal on 04/12/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var subjectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.reloadData()
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "") as! NotificationsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationsSelectionImageView: UIImageView!
}
