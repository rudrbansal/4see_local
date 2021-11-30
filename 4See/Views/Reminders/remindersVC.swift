//
//  remindersVC.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu
import EventKit
import EventKitUI

enum timeSlots{
    case fifteenMins
    case thirtyMins
    case sixtyMins
}

class remindersVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "remindersVC"
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var listVW: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var checkImg2: UIImageView!
    @IBOutlet weak var checkImg3: UIImageView!
    @IBOutlet weak var banner_img: UIImageView!
    var slot : timeSlots = .fifteenMins
    var type = ""
    let eventStore = EKEventStore()
    let viewModel = attendanceViewModel()
    let reminderViewModel = ReminderViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        designLayout()
    }
    
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        checkImg.image = UIImage(named: "checkmark")
        checkImg2.image = UIImage(named: "uncheck")
        checkImg3.image = UIImage(named: "uncheck")
    }
    
    func designLayout()
    {
        if type == "Attendance"
        {
            titleLbl.text = "Work Attendance"
            banner_img.image = UIImage(named: "bioMatric_banner")
        }
        else
        {
            titleLbl.text = "Work From Home"
            banner_img.image = UIImage(named: "wfh_banner")

        }
    }
    
    @IBAction func back(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func listBtnAction(_ sender: Any)
    {
        switch (sender as AnyObject).tag{
        case 1:
            slot = .fifteenMins
            checkImg.image = UIImage(named: "checkmark")
            checkImg2.image = UIImage(named: "uncheck")
            checkImg3.image = UIImage(named: "uncheck")

        case 2:
            slot = .thirtyMins
            checkImg2.image = UIImage(named: "checkmark")
            checkImg.image = UIImage(named: "uncheck")
            checkImg3.image = UIImage(named: "uncheck")

        case 3:
            slot = .sixtyMins
            checkImg3.image = UIImage(named: "checkmark")
            checkImg2.image = UIImage(named: "uncheck")
            checkImg.image = UIImage(named: "uncheck")

        default:
            print("no")
        }
    }
    
    func AddReminder() {
        
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            granted, error in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                
                
                let reminder:EKReminder = EKReminder(eventStore: self.eventStore)
                reminder.title = "Must do this!"
                reminder.priority = 2
                
                //  How to show completed
                //reminder.completionDate = Date()
                
                reminder.notes = "...this is a note"
                
                
                let alarmTime = Date().addingTimeInterval(1*60*24*3)
                let alarm = EKAlarm(absoluteDate: alarmTime)
                reminder.addAlarm(alarm)
                
                reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
                do {
                    try self.eventStore.save(reminder, commit: true)
                } catch {
                    print("Cannot save")
                    return
                }
                print("Reminder saved")
            }
        })
        
    }
    
    func animateCheckbox()
    {
        if slot == .fifteenMins
        {
            let objc = remindVC()
            objc.timeSlot = "Remember to clock out in 15min"
            objc.type = type
            self.navigationController?.pushViewController(objc)
        }
        else if slot == .thirtyMins
        {
            let objc = remindVC()
            objc.timeSlot = "Remember to clock out in 30min"
            objc.type = type
            self.navigationController?.pushViewController(objc)
        }
        else if slot == .sixtyMins
        {
            let objc = remindVC()
            objc.timeSlot = "Remember to clock out in 60min"
            objc.type = type
            self.navigationController?.pushViewController(objc)
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.addAttendanceAPI()
    }
    
}

extension remindersVC {
    
    func addAttendanceAPI() {
        self.showProgressBar()
        viewModel.setAttendanceValues(AppConfig.loggedInUser!.userInfo!.id!,Date().getDateYYYYMMDDString())
        viewModel.addAttendApi { (status,message) in
            if status == true
            {
                self.hideProgressBar()
                if self.type == "Work From Home"
                {
                    UserDefaults.standard.setValue("HomeCheckIn", forKey: "attendance_status")
                }
                else
                {
                    UserDefaults.standard.setValue("WorkCheckIn", forKey: "attendance_status")
                }
                self.showToast(message)
                self.setReminder()
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                for aViewController in viewControllers {
                    if aViewController is HomeViewController {
                        self.navigationController!.popToViewController(aViewController, animated: true)
                    }
                }
            }
            else
            {
                self.hideProgressBar()
            }
        }
    }
    
    func setReminder() {
        var alarm = "15"
        switch slot {
        case .fifteenMins:
            alarm = "15"
        case .thirtyMins:
            alarm = "30"
        case .sixtyMins:
            alarm = "60"
        }
        reminderViewModel.setValues(alarm)
        reminderViewModel.updateProfileAlarmAPI()
    }
    
}
