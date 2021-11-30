//
//  remindVC.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu

class remindVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "remindVC"
    }
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bannerImg: UIImageView!
    var timeSlot = ""
    var callback : ((String) -> Void)?
    var type = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        designLayout()
    }
    func designLayout()
    {
        timeLbl.text = timeSlot
       
            if type == "Attendance"
            {
                titleLBL.text = "Work Attendance"
                bannerImg.image = UIImage(named: "bioMatric_banner")
            }
            else
            {
                titleLBL.text = "Work From Home"
                bannerImg.image = UIImage(named: "wfh_banner")

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
    
    @IBAction func dismissReminderAction(_ sender: Any)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is biometricsVC {
                GlobalVariable.dismiss = "dismiss_reminder"
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
}
