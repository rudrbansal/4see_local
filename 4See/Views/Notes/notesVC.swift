//
//  notesVC.swift
//  4See
//
//  Created by Gagan Arora on 06/04/21.
//

import UIKit
import SideMenu

class notesVC: BaseViewController {
    override class var storyboardIdentifier: String
    {
        return "notesVC"
    }
    @IBOutlet weak var notesTable: UITableView!
    var viewModel = notesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initSideMenuView()
    }
    override func viewDidAppear(_ animated: Bool) {
        getNotesListAPI()
    }
    private func configureTableView() {
        
        notesTable.register(nibWithCellClass: noteCell.self)
        notesTable.register(nibWithCellClass: addNoteCell.self)
    }
    //MARK:- SideMenu Functiony
    
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
extension notesVC: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return (viewModel.notesList?.data!.count)!
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.section == 0) {
        let cell = tableView.dequeueReusableCell(withClass: noteCell.self)
            cell.cellModel = viewModel.notesList?.data![indexPath.row]
            cell.ButtonViewClicked = { [self] in
                let objc = noteDetailsVC()
                objc.type = "edit"
                objc.viewModel.selectedNoteInfo = viewModel.notesList?.data![indexPath.row]
                self.navigationController?.pushViewController(objc, completion: nil)
            }
            cell.configureShadow()
            return cell
        }else{
            let cell2 = tableView.dequeueReusableCell(withClass: addNoteCell.self)
            cell2.buttonAddClicked = {
                let objc = noteDetailsVC()
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
extension notesVC {
    
    func getNotesListAPI() {
        self.showProgressBar()
        viewModel.getNotesAPI { (status,message)  in
            if status == true
            {
                self.hideProgressBar()
                self.notesTable.reloadData()
                self.notesTable.delegate = self
                self.notesTable.dataSource = self
            }
            else
            {
                self.hideProgressBar()
            }
        }
    }

}
