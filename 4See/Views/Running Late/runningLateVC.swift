//
//  runningLateVC.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu

class runningLateVC: BaseViewController,UITextViewDelegate
{
    override class var storyboardIdentifier: String
    {
        return "runningLateVC"
    }
    @IBOutlet weak var reasonTFT: UITextField!
    @IBOutlet weak var dateLbl1: UILabel!
    @IBOutlet weak var dateLbl2: UILabel!
    @IBOutlet weak var msgTxtVW: UITextView!
    
    let viewModel = attendanceViewModel()
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTxtVW.delegate = self
        initSideMenuView()
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        reasonTFT.setPlaceholder("Reason:", withColor: BaseColors.themeColor)
        msgTxtVW.text = "Message/Notes:"
        msgTxtVW.textColor = BaseColors.themeColor
    }
    @IBAction func back(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func datePickerOpen(_ sender: Any)
    {
        switch (sender as AnyObject).tag {
        case 1:
            RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
                // TODO: Your implementation for date
                let datee = selectedDate.dateString("hh:mm").components(separatedBy: ":")
                print(datee)
                self!.dateLbl1.text = datee[0]
                self!.dateLbl2.text = datee[1]

            })
        case 2:
            RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
                // TODO: Your implementation for date
                let datee = selectedDate.dateString("hh:mm").components(separatedBy: ":")
                print(datee)
                self!.dateLbl1.text = datee[0]
                self!.dateLbl2.text = datee[1]

            })
        default:
            print("no")
        }
       
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if reasonTFT.text == "" && dateLbl1.text == "00" && dateLbl2.text == "00" && msgTxtVW.text == "Message/Notes:"
        {
            showToast("All fields are required.")
        }
        else if reasonTFT.text == ""
        {
            showToast("Reason is required.")
        }
        else if dateLbl1.text == "00"
        {
            showToast("Time duration is required.")
        }
        else if msgTxtVW.text == "Message/Notes:"
        {
            showToast("Message/Note is required.")

        }
        else
        {
            addAttendanceAPI()

        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTxtVW.textColor == BaseColors.themeColor {
            msgTxtVW.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxtVW.text.isEmpty {
            msgTxtVW.text = "Message/Notes:"
            msgTxtVW.textColor = BaseColors.themeColor
        }
    }
}
extension Date {
    
    func dateString(_ format: String = "yyyy-MM-dd, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    func dateByAddingWeek(_ dWeek: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.weekday = dWeek
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}
extension runningLateVC {
    
    func addAttendanceAPI() {
        self.showProgressBar()
        viewModel.setLateValues(AppConfig.loggedInUser!.userInfo!.id!,Date().getDateYYYYMMDDString(),"2", dateLbl1.text!+"."+dateLbl2.text!,reasonTFT.text!,msgTxtVW.text!)
        viewModel.lateAttendApi { (status,message) in
            if status == true
            {
                self.hideProgressBar()
                self.showToast(message)
                self.reasonTFT.text = ""
                self.msgTxtVW.text = "Message/Notes:"
                self.dateLbl1.text = "00"
                self.dateLbl1.text = "00"
                

            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
    }

}
