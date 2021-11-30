//
//  announcementsViewController.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu

class announcementsViewController: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "announcementsViewController"
    }
    @IBOutlet weak var eventsTable: UITableView!
    let viewModel = announcementViewModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        getAnnouncementsData()

        configureTableView()
        initSideMenuView()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        getAnnouncementsData()
    }
    private func configureTableView() {
       
        eventsTable.register(nibWithCellClass: announcementCell.self)
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController

    }
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
    
}
extension announcementsViewController: UITableViewDelegate,UITableViewDataSource
{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.announcementsList!.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withClass: announcementCell.self)
        cell.cellModel = self.viewModel.announcementsList!.data[indexPath.row]
        cell.ButtonClicked = {
            let objc = announceDetailsVC()
            objc.viewModel.details = self.viewModel.announcementsList!.data[indexPath.row]
             self.navigationController?.pushViewController(objc)

        }
        cell.configureShadow()
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
}
extension announcementsViewController {
    
    func getAnnouncementsData() {
        self.showProgressBar()
        viewModel.getAnnouncementsAPI { (status, message) in
            if status == true
            {
                self.hideProgressBar()
                self.eventsTable.reloadData()
                self.eventsTable.delegate = self
                self.eventsTable.dataSource = self
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
    }
    
}
