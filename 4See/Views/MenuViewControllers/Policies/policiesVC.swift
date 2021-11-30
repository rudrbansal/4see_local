//
//  policiesVC.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu

class policiesVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "policiesVC"
    }
    
    @IBOutlet weak var policiesTable: UITableView!
    var viewModel = PolicyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getPoliciesData()
    }
    private func configureTableView() {
        policiesTable.register(nibWithCellClass: policyCell.self)

    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }

    @IBAction func back(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
    
}
extension policiesVC: UITableViewDelegate,UITableViewDataSource
{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.policiesList!.data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withClass: policyCell.self)
            cell.configureShadow()
        cell.cellModel = viewModel.policiesList!.data![indexPath.row]
        cell.ButtonClicked = {
            let objc = webVC()
            objc.viewModel.selectedLeaveInfo = self.viewModel.policiesList!.data![indexPath.row]
            objc.modalPresentationStyle = .overFullScreen
            self.present(objc, animated: true, completion: nil)
        }
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 70
    }
    
}
extension policiesVC {
    
    func getPoliciesData() {
        self.showProgressBar()
        viewModel.getPoliciesAPI { (status,message) in
            if status == true
            {
                self.hideProgressBar()
                self.policiesTable.reloadData()
                self.policiesTable.delegate = self
                self.policiesTable.dataSource = self
            }
            else
            {
                self.hideProgressBar()
            }
        }
    }
 
}
