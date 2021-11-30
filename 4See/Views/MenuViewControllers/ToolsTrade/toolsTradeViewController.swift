//
//  toolsTradeViewController.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu

class toolsTradeViewController: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "toolsTradeViewController"
    }
    
    @IBOutlet weak var itemsTable: UITableView!
    let viewModel = toolsTradeViewModel()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureTableView()
        initSideMenuView()
    }
    
    private func configureTableView() {
        itemsTable.register(nibWithCellClass: dataCell.self)
        itemsTable.register(nibWithCellClass: addcell.self)
    }
    override func viewDidAppear(_ animated: Bool) {
        getSystemsData()
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
extension toolsTradeViewController: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return viewModel.systemsList!.data!.count 
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.section == 0) {
        let cell = tableView.dequeueReusableCell(withClass: dataCell.self)
            cell.cellModel = viewModel.systemsList!.data![indexPath.row]
            cell.ButtonViewClicked = {
                let objc = editToolsViewController()
                objc.type = "edit"
                self.showProgressBar()

                objc.viewModel.selectedSystemInfo = self.viewModel.systemsList!.data![indexPath.row]
                self.navigationController?.pushViewController(objc, completion: nil)
            }
            cell.configureShadow()
            return cell
        }else{
            let cell2 = tableView.dequeueReusableCell(withClass: addcell.self)
            cell2.buttonAddClicked = {
                let objc = editToolsViewController()
                objc.type = "add"
                self.navigationController?.pushViewController(objc)
            }
            return cell2
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 80
        }
        else
        {
            return 50
        }
    }
}
extension toolsTradeViewController {
    
    func getSystemsData() {
        self.showProgressBar()
        viewModel.getSystemsAPI { (status,message) in
            if status == true
            {
                self.hideProgressBar()
                self.itemsTable.reloadData()
                self.itemsTable.delegate = self
                self.itemsTable.dataSource = self
            }
            else
            {
                self.hideProgressBar()
            }
        }
    }
    
}
