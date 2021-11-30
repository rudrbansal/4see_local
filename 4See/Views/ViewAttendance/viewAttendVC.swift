//
//  viewAttendVC.swift
//  4See
//
//  Created by Gagan Arora on 08/04/21.
//

import UIKit
import SideMenu

class viewAttendVC: BaseViewController {

    override class var storyboardIdentifier: String
    {
        return "viewAttendVC"
    }
    @IBOutlet weak var textVw: UITextView!
    var viewModel = notesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        textVw.text = viewModel.selectedNoteInfo?.note!
    }
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    
}
