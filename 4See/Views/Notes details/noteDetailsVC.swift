//
//  noteDetailsVC.swift
//  4See
//
//  Created by Gagan Arora on 07/04/21.
//

import UIKit
import SideMenu

class noteDetailsVC: BaseViewController,UITextViewDelegate
{
    override class var storyboardIdentifier: String
    {
        return "noteDetailsVC"
    }
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var noteNameTFT: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var txtView: UITextView!
    var type = ""
    var viewModel = notesViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        txtView.delegate = self
        dataSetup()
    }
    //MARK:- SideMenu Function().........
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    func dataSetup()
    {
        if type == "edit"
        {
            noteNameTFT.setPlaceholder("Name:", withColor: BaseColors.themeColor)
            noteNameTFT.text = viewModel.selectedNoteInfo?.name
            descLbl.text = "View or edit note"
            txtView.text = viewModel.selectedNoteInfo?.note!
            saveBtn.setTitle("Save Edit", for: .normal)
        }
        else
        {
            noteNameTFT.setPlaceholder("Name:", withColor: BaseColors.themeColor)

            descLbl.text = "Add a new note to your time"
            txtView.text = "Note:"
            txtView.textColor = UIColor.black
            saveBtn.setTitle("Save Note", for: .normal)

        }
    }
    //MARK:- IBActions().........

    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
    @IBAction func saveEdit(_ sender: Any)
    {
        if type == "edit"
        {
            editNoteApi()
        }
        else
        {
            addNoteApi()

        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.textColor == UIColor.black {
            txtView.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text.isEmpty {
            txtView.text = "Note:"
            txtView.textColor = UIColor.black
        }
    }
}
extension noteDetailsVC {
    
    func addNoteApi() {
        viewModel.addNoteValues(txtView.text!,noteNameTFT.text!)
        self.showProgressBar()
        viewModel.addNoteAPI { (status,message)  in
            if status == true
            {
                self.hideProgressBar()
                self.showToast(message)
                self.navigationController?.popViewController()

            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)

            }
        }
    }
    func editNoteApi() {
        viewModel.editNoteValues(txtView.text!,self.viewModel.selectedNoteInfo!._id!,noteNameTFT.text!)
        self.showProgressBar()
        viewModel.editNoteAPI { (status,message)  in
            if status == true
            {
                self.hideProgressBar()
                self.showToast(message)
                self.navigationController?.popViewController()
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)

            }
        }
    }

}
