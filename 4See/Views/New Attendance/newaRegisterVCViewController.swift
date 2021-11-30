//
//  newaRegisterVCViewController.swift
//  4See
//
//  Created by Gagan Arora on 08/04/21.
//

import UIKit
import SideMenu

class newaRegisterVCViewController: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "newaRegisterVCViewController"
    }

    @IBOutlet weak var attendTable: UITableView!
    var viewModel = notesViewModel()
    let secondModel = attendanceViewModel()
    var breakIn: Bool = false
    var timer = Timer()
    var totalTime: Int!
    var hours: Int!
    var minutes: Int!
    var seconds: Int!
    var finalBreakTIme : Int!
    var clockOutTime : Int!

    var timme : String!
    var date : String!
    var comeFrom = ""
    var startDate:String!
    var endDate:String!
    var breakk = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        configureTableView()
        getAttendanceDetailsAPI()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        getAttendanceDetailsAPI()
    }
    private func configureTableView() {
      
        attendTable.register(nibWithCellClass: attendTimerCell.self)
        attendTable.register(nibWithCellClass: infoCell.self)
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }

    @IBAction func menuAction(_ sender: Any){
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
   
}
extension newaRegisterVCViewController: UITableViewDelegate,UITableViewDataSource
{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0
        {
            return 1
        }else{
            return secondModel.checkInReverseList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if (indexPath.section == 0) {
        let cell = attendTable.dequeueReusableCell(withClass: attendTimerCell.self)
            print(breakk)
            if breakk == "On"
            {
                cell.BreakTimeLbl.backgroundColor = UIColor.red
            }
            else
            {
                cell.BreakTimeLbl.backgroundColor = UIColor.clear

            }
            if date == ""
            {
                cell.DateLbl.text = createTrackingStamp(dateFromBackEnd: Date().getDateddMMMYYYYString())

            }
            else
            {
                cell.DateLbl.text = date
            }
            secondModel.checkInReverseList = secondModel.checkInList.reversed()
            if secondModel.checkInReverseList[secondModel.checkInReverseList.count - 1].chekcIntype == "CheckOut"
            {
                cell.contentView.backgroundColor = UIColor.systemRed
            }
            else  if secondModel.checkInReverseList[secondModel.checkInReverseList.count - 1].chekcIntype == "HomeCheckOut"
            {
                cell.contentView.backgroundColor = UIColor.systemRed
            }
            else
            {
                cell.gradientViewSetup(view: cell.contentView)
                
            }
        
            let hour = secondModel.Breaktimee / 3600
            let minute = secondModel.Breaktimee / 60 % 60
            let second = secondModel.Breaktimee % 60
            cell.BreakTimeLbl.text = "Break: \(String(format: "%02d:%02d:%02d", hour, minute, second))"
            
            if self.comeFrom == "register"
           {
                print(totalTime)

                let hours = secondModel.timee / 3600
                let minutes = secondModel.timee / 60 % 60
                let seconds = secondModel.timee % 60
                cell.timerLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                
                let hour = secondModel.Breaktimee / 3600
                let minute = secondModel.Breaktimee / 60 % 60
                let second = secondModel.Breaktimee % 60
                cell.BreakTimeLbl.text = "Break: \(String(format: "%02d:%02d:%02d", hour, minute, second))"

                let h = secondModel.checkOuttimee / 3600
                let m = secondModel.checkOuttimee / 60 % 60
                let s = secondModel.checkOuttimee % 60
                cell.clockedOut.text =  "Clocked Out:\(String(format: "%02d:%02d:%02d", h, m, s))"

            }
          
            else
            {
                print(totalTime)
                let hours = totalTime / 3600
                let minutes = totalTime / 60 % 60
                let seconds = totalTime % 60
                cell.timerLbl.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                
                let hour = finalBreakTIme / 3600
                let minute = finalBreakTIme / 60 % 60
                let second = finalBreakTIme % 60
                cell.BreakTimeLbl.text = "Break: \(String(format: "%02d:%02d:%02d", hour, minute, second))"

                let h = secondModel.checkOuttimee / 3600
                let m = secondModel.checkOuttimee / 60 % 60
                let s = secondModel.checkOuttimee % 60
                cell.clockedOut.text =  "Clocked Out : \(String(format: "%02d:%02d:%02d", h, m, s))"

            }
         
            let arrr = self.secondModel.checkInReverseList[0].date?.components(separatedBy: "T")
            
            let ar = arrr![1].components(separatedBy: ":")
            print(Date())
            cell.clockedInTimeLbl.text = "Clocked In: \(ar[0]):\(ar[1])"

        return cell
        }else{
            let cell2 = attendTable.dequeueReusableCell(withClass: infoCell.self)
            cell2.cellModel = secondModel.checkInReverseList[indexPath.row]
            cell2.viewBtn.setTitle(secondModel.checkInReverseList[indexPath.row].chekcIntype, for: .normal)
            cell2.configureShadow()
            cell2.ButtonClicked = {
             let objc = viewAttendVC()
                objc.viewModel.selectedNoteInfo = self.viewModel.notesList?.data![indexPath.row]
                self.navigationController?.pushViewController(objc)
            }
            return cell2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 130
        }
        else
        {
            return 65
        }
    }
    
    
}
extension newaRegisterVCViewController {
    
    func getAttendanceDetailsAPI() {
        self.showProgressBar()
        let arr = startDate!.components(separatedBy: "T")
        secondModel.setAttendanceDetailsValues(arr[0] + "T00:01:00.000Z", arr[0] + "T23:59:59.000Z")
        secondModel.getAttendanceDetailsApi { [self](status,message)  in
            if status == true
            {
                self.hideProgressBar()
                self.attendTable.reloadData()
                self.attendTable.delegate = self
                self.attendTable.dataSource = self
                secondModel.checkInReverseList = secondModel.checkInList.reversed()
                if self.comeFrom == "register"
               {
                    if secondModel.checkInReverseList.count == 1
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                        let start = dateFormatter.date(from:secondModel.checkInReverseList[0].date!)
                        
                        let diffComponents = Calendar.current.dateComponents([.hour, .minute,.second],from: Date(), to: start!)
                        print(diffComponents)
                        
                        secondModel.timee = diffComponents.hour! * 3600 + diffComponents.minute! * 60 +  diffComponents.second!
                        print(secondModel.timee as Any)
                     
                        print(secondModel.timee!)
                        
                    }
                    else
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                        let start = dateFormatter.date(from:secondModel.checkInReverseList[0].date!)
                        let end = dateFormatter.date(from:secondModel.checkInReverseList[secondModel.checkInReverseList.count - 1].date!)
                        
                        let diffComponents = Calendar.current.dateComponents([.hour, .minute,.second],from: start!, to: end!)
                        print(diffComponents)
                        
                        secondModel.timee = diffComponents.hour! * 3600 + diffComponents.minute! * 60 +  diffComponents.second!
                        print(secondModel.timee as Any)
                     
                        print(secondModel.timee!)
                    }
                  
               }
                
                for ind in 0..<secondModel.checkInReverseList.count
                {
                    if secondModel.checkInReverseList[ind].chekcIntype == "CheckIn"
                    {
                        

                        secondModel.breakkList = secondModel.checkInReverseList.filter { !$0.chekcIntype!.contains("CheckIn")}

                    }
                    else if secondModel.checkInReverseList[ind].chekcIntype == "HomeCheckIn"
                    {
                        

                        secondModel.breakkList = secondModel.checkInReverseList.filter { !$0.chekcIntype!.contains("HomeCheckIn")}

                    }
                    else if secondModel.checkInReverseList[ind].chekcIntype == "CheckIn" || secondModel.checkInReverseList[ind].chekcIntype == "CheckOut"
                    {
                        
                        secondModel.checkOutList = secondModel.checkInReverseList.filter { $0.chekcIntype!.contains("CheckIn") || $0.chekcIntype!.contains("CheckOut")}

                        secondModel.breakkList = secondModel.checkInReverseList.filter { !$0.chekcIntype!.contains("CheckIn") || !$0.chekcIntype!.contains("CheckOut")}

                    }
                    else if secondModel.checkInReverseList[ind].chekcIntype == "HomeCheckIn" || secondModel.checkInReverseList[ind].chekcIntype == "HomeCheckOut"
                    {
                        
                        secondModel.checkOutList = secondModel.checkInReverseList.filter { $0.chekcIntype!.contains("HomeCheckIn") || $0.chekcIntype!.contains("HomeCheckOut")}

                        print(secondModel.timee)
                        secondModel.breakkList = secondModel.checkInReverseList.filter { !$0.chekcIntype!.contains("HomeCheckIn") || !$0.chekcIntype!.contains("HomeCheckOut")}
                        

                    }
                    if secondModel.checkOutList.count != 0
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                        print(secondModel.checkOutList)
                        print(secondModel.checkInReverseList)

                        let start = dateFormatter.date(from:secondModel.checkOutList[0].date!)
                        let end = dateFormatter.date(from:secondModel.checkOutList[secondModel.checkOutList.count - 1].date!)
                        let diComponents = Calendar.current.dateComponents([.hour, .minute,.second],from: start!, to: end!)
                        print(diComponents)
                      
                        secondModel.checkOuttimee = diComponents.hour! * 3600 + diComponents.minute! * 60 +  diComponents.second!
                        print(secondModel.checkOuttimee)

                    }

                    else
                    {
                        secondModel.checkOuttimee = 0
                        print("No")

                    }
                    if secondModel.breakkList.count != 0
                    {
                      
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                            let start = dateFormatter.date(from:secondModel.breakkList[0].date!)
                            let end = dateFormatter.date(from:secondModel.breakkList[secondModel.breakkList.count - 1].date!)
                            let diComponents = Calendar.current.dateComponents([.hour, .minute,.second],from: start!, to: end!)
                            print(diComponents)
                          
                            secondModel.Breaktimee = diComponents.hour! * 3600 + diComponents.minute! * 60 +  diComponents.second!
                            print(secondModel.Breaktimee)
                       
                    }
                    else
                    {
                        secondModel.Breaktimee = 0
                        print("No")
                    }
                }
            }
            else
            {
                self.hideProgressBar()
            }
        }
    }


}
