//
//  msgDetailsVC.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu

enum buttonType
{
    case favourite
    case delete
}

class msgDetailsVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "msgDetailsVC"
    }
    @IBOutlet weak var msgTxtView: UITextView!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var favlable: UILabel!
    
    @IBOutlet weak var deleteLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var type : buttonType = .favourite
    var viewModel = messageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSideMenuView()
        deleteLbl.text = "Delete"
        getMessagesDetailsAPI()
        let arr = viewModel.selectedMsgInfo?.createdAt!.components(separatedBy: "T")
        msgTxtView.text =  "Reply \n\(String(describing: viewModel.selectedMsgInfo!.subject!))\n\(String(describing: arr![0]))\n\n\(String(describing: viewModel.selectedMsgInfo!.body!))"
    }
    //MARK:- Color Transition...
    
    func transitionButtons()
    {
        if viewModel.selectedMsgInfo?.recipients?.isFavorite == "1"
        {
            favouriteView.backgroundColor = BaseColors.themeColor
            favImg.image = UIImage(named: "white_star")
            favlable.textColor = UIColor.white
        }
        else
        {
            deleteLbl.text = "Delete"
        }
        if viewModel.selectedMsgInfo?.recipients?.isDeleted == "1"
        {
            deleteLbl.text = "Deleted"
        }
        else
        {
            favouriteView.backgroundColor = .clear
            favImg.image = UIImage(named: "blue_star")
            favlable.textColor = BaseColors.themeColor
        }
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
    
    @IBAction func segmentButtonAction(_ sender: Any)
    {
        switch (sender as AnyObject).tag {
        case 1:
            print("Favourite")
            favouriteMessageAPI()
        case 2:
            print("Delete")
            getMessagesDeleteAPI()
        default:
            print("no")
        }
        
    }
    
    @IBAction func replyAction(_ sender: Any)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is messageVC {
                GlobalVariable.msgType = "Reply"
                GlobalVariable.selectedMsginfo = viewModel.selectedMsgInfo!
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
}
extension msgDetailsVC {
    
    func favouriteMessageAPI() {
        self.showProgressBar()
        self.viewModel.favouriteMsgValues(viewModel.selectedMsgInfo!.recipients!._id!)
        viewModel.favMsgAPI { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                self.showToast(message)
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)

            }
        }
    }
    func getMessagesDetailsAPI() {
        self.showProgressBar()
        
        if viewModel.selectedMsgInfo?.recipients == nil {
            self.viewModel.detailsMsgValues(viewModel.selectedMsgInfo!._id ?? "")
        } else {
            self.viewModel.detailsMsgValues(viewModel.selectedMsgInfo!.recipients!._id!)
        }
        viewModel.detailsApi { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                self.hideProgressBar()
                self.transitionButtons()

            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)

            }
        }
    }
    func getMessagesDeleteAPI() {
        self.showProgressBar()
        
        self.viewModel.deleteMsgValues(viewModel.selectedMsgInfo!._id!)
        viewModel.deleteMsgApi { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                self.hideProgressBar()
                self.transitionButtons()
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)

            }
        }
    }
}
