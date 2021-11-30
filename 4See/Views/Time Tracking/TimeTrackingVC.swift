//
//  TimeTrackingVC.swift
//  4See
//
//  Created by Gagan Arora on 06/04/21.
//

import UIKit
import MagicTimer
import SideMenu

class TimeTrackingVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "TimeTrackingVC"
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bannerIng: UIImageView!
    @IBOutlet weak var timerView: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var clockedInTimeLbl: UILabel!
    
    @IBOutlet weak var breakLbl: UILabel!
    @IBOutlet weak var breakImg: UIImageView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var breakView: UILabel!
    let viewModel = attendanceViewModel()
    var type = ""
    var breakIn: Bool = false
    var timer = Timer()
    var Btimer = Timer()
    var breakk = ""

    var totalTime: Int!
    var breakTime: Int!
    var breakDateArr = [Date]()

    var breakOutArr = [Int]()
    var breakInArr = [Int]()
    var totalBreakINTime = 0
    var totalBreakOutTime = 0
    var finalBreakTIme = 0
    var newDateArr = [[Date]]()
    var finalBreakDateArr = [Date]()

    var newArr = [[Int]]()
    var finalBreakArr = [Int]()
    var checkoutDateArr = [Date]()
    var newCheckOutDateArr = [[Date]]()
    var finalCheckOutArr = [Int]()
    var finalCheckoutTIme = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if type == "Work From Home"
        {
            titleLbl.text = "Work From Home"
            bannerIng.image = UIImage(named: "wfh_banner")
        }
        else
        {
            titleLbl.text = "Work Attendance"
            bannerIng.image = UIImage(named: "bioMatric_banner")
            
        }
        gradientViewSetup(view: trackingView)
        dateLBL.text = createTrackingStamp(dateFromBackEnd: Date().getDateddMMMYYYYString())
        getAttendanceListAPI { (status) in
            if status {
                self.startBTimer()
            }
        }
        
        initSideMenuView()
    }
    //MARK:- SideMenu Function().........
    
    func initSideMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        breakInArr.removeAll()
        breakOutArr.removeAll()
        finalBreakArr.removeAll()
        newArr.removeAll()
        newDateArr.removeAll()
        finalBreakDateArr.removeAll()
        breakDateArr.removeAll()
    }
   
    @IBAction func menuAction(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        totalTime += 1
        let hours = totalTime / 3600
        let minutes = totalTime / 60 % 60
        let seconds = totalTime % 60
        timerView.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        AppConfig.totalTime = timerView.text
    }
    
    func endTimer() {
        timer.invalidate()
    }
       
    //MARk:- Break
    
    func startBTimer() {
        Btimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBTime), userInfo: nil, repeats: true)
    }
   
    @objc func updateBTime() {
        print(finalBreakTIme)
        
        finalBreakTIme += 1
        
        let hours = finalBreakTIme / 3600
        let minutes = (finalBreakTIme % 3600) / 60
        let seconds = (finalBreakTIme % 3600) % 60
        
        breakView.text = String(format: "%02d:%02d:%02d",hours, minutes, seconds)
        AppConfig.breakTime = breakView.text
        breakk = "On"
    }

    func endBTimer() {
        Btimer.invalidate()
        breakk = "Off"
    }
    
    @IBAction func optionActions(_ sender: Any) {
        self.breakOutArr.removeAll()
        self.breakInArr.removeAll()

        switch (sender as AnyObject).tag{
        case 1:
            if viewModel.breakList.count != 0 {
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "CheckIn" {
                    breakIn = true
                    breakImg.image = UIImage(named: "icon0")
                    view1.backgroundColor = UIColor.systemRed
                    breakLbl.textColor = UIColor.white
                    breakLbl.text = "Stop Break"
                    self.addBreakAPI(type: "0", checkIn: "BreakIn",startBKTimer: true)
                }
                
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "HomeCheckIn" {
                    breakIn = true
                    view1.backgroundColor = UIColor.systemRed
                    breakImg.image = UIImage(named: "icon0")
                    breakLbl.textColor = UIColor.white
                    breakLbl.text = "Stop Break"
                    self.addBreakAPI(type: "1", checkIn: "HomeBreakIn",startBKTimer: true)
                }
                
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "CheckOut" {
                    breakIn = true
                    breakImg.image = UIImage(named: "icon0")
                    view1.backgroundColor = UIColor.systemRed
                    breakLbl.textColor = UIColor.white
                    breakLbl.text = "Stop Break"
                    self.addBreakAPI(type: "0", checkIn: "BreakIn",startBKTimer: true)
                }
                
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "HomeCheckOut" {
                    breakIn = true
                    view1.backgroundColor = UIColor.systemRed
                    breakImg.image = UIImage(named: "icon0")
                    breakLbl.textColor = UIColor.white
                    breakLbl.text = "Stop Break"
                    self.addBreakAPI(type: "1", checkIn: "HomeBreakIn",startBKTimer: true)
                }
                
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "BreakIn" {
                    self.addBreakAPI(type: "0", checkIn: "BreakOut")
                }
               
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "HomeBreakIn" {
                    self.addBreakAPI(type: "1", checkIn: "HomeBreakOut")
                }
                
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "BreakOut" {
                    self.addBreakAPI(type: "0", checkIn: "BreakIn",startBKTimer: true)
                }
                
                if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "HomeBreakOut" {
                    self.addBreakAPI(type: "1", checkIn: "HomeBreakIn",startBKTimer: true)
                }
            } else {
                if viewModel.attendList[0].chekcIntype == "CheckIn" {
                    breakIn = true
                    breakImg.image = UIImage(named: "icon0")
                    view1.backgroundColor = UIColor.systemRed
                    breakLbl.textColor = UIColor.white
                    breakLbl.text = "Stop Break"
                    self.addBreakAPI(type: "0", checkIn: "BreakIn",startBKTimer: true)
                }
              
                if viewModel.attendList[0].chekcIntype == "HomeCheckIn" {
                    breakIn = true
                    view1.backgroundColor = UIColor.systemRed
                    breakImg.image = UIImage(named: "icon0")
                    breakLbl.textColor = UIColor.white
                    breakLbl.text = "Stop Break"
                    self.addBreakAPI(type: "1", checkIn: "HomeBreakIn",startBKTimer: true)
                }
                
            }
        case 2:
            print("Add Notes")
           
            let objc = notesVC()
            self.navigationController?.pushViewController(objc)
        case 3:
            print("TimeSheet")
            let objc = newaRegisterVCViewController()
            objc.finalBreakTIme = finalBreakTIme
            objc.totalTime = totalTime
            objc.breakk = breakk
            objc.clockOutTime = Int(AppConfig.checkOutTime)
            objc.date = ""
            objc.startDate = viewModel.attendList[0].date!
            print(viewModel.attendList)
            objc.comeFrom = "tracking"
            print(viewModel.attendList[0].date!)
            AppConfig.totalTime = timerView.text!
            self.navigationController?.pushViewController(objc)
        case 4:
            print("Clock out")
            
            let alertController = UIAlertController(title: "4See", message: "Are you sure you want to end the day?", preferredStyle: .alert)
            let btnYes = UIAlertAction(title: "Yes", style: .default)
            { (action:UIAlertAction!) in
                if self.type == "Work From Home"
                {
                    self.addAttendanceAPI(type: "1", checkIn: "HomeCheckOut")
                    self.navigationController?.popViewController()
                }
                else
                {
                    self.addAttendanceAPI(type: "0", checkIn: "CheckOut")
                    self.navigationController?.popViewController()
                    
                }
            }
            let btnCancel = UIAlertAction(title: "Cancel", style: .default)
            { (action:UIAlertAction!) in
                
            }
            alertController.addAction(btnYes)
            alertController.addAction(btnCancel)
            self.present(alertController, animated: true, completion:nil)
        default:
            print("No")
        }
    }
   
}

extension TimeTrackingVC {
    
    func addAttendanceAPI(type:String, checkIn:String) {
        self.showProgressBar()
        self.endTimer()
        viewModel.attendanceType = type
        viewModel.attendanceCheckInType = checkIn
        viewModel.setAttendanceValues(AppConfig.loggedInUser!.userInfo!.id!,Date().getDateYYYYMMDDString())
        viewModel.addAttendApi { (status,message) in
            if status == true {
                self.hideProgressBar()
                if self.type == "Work From Home" {
                    self.endTimer()
                    UserDefaults.standard.setValue("HomeCheckOut", forKey: "attendance_status")
                    UserDefaults.standard.setValue(Date(), forKey: "end_time")
                } else {
                    self.endTimer()
                    UserDefaults.standard.setValue("WorkCheckOut", forKey: "attendance_status")
                    UserDefaults.standard.setValue(Date(), forKey: "end_time")
                }
                self.showToast(message)
            } else {
                self.hideProgressBar()
            }
        }
    }
    
    func addBreakAPI(type:String, checkIn:String,startBKTimer:Bool = false) {
        self.showProgressBar()
        self.endTimer()
        viewModel.attendanceType = type
        viewModel.attendanceCheckInType = checkIn
        viewModel.setAttendanceValues(AppConfig.loggedInUser!.userInfo!.id!,Date().getDateYYYYMMDDString())
        viewModel.addAttendApi { (status,message) in
            if status == true {
                self.hideProgressBar()
                if self.type == "Work From Home" {
                    UserDefaults.standard.setValue("HomeBreakOut", forKey: "attendance_status")
                    UserDefaults.standard.setValue(Date(), forKey: "end_time")
                } else {
                    UserDefaults.standard.setValue("BreakOut", forKey: "attendance_status")
                    UserDefaults.standard.setValue(Date(), forKey: "end_time")
                }
                self.showToast(message)
                self.getAttendanceListAPI {_ in
                    if startBKTimer {
                        self.startBTimer()
                    } else {
                        self.endBTimer()
                    }
                }
            } else {
                self.hideProgressBar()
            }
        }
    }
    
    func getAttendanceListAPI(_ completionHandler: @escaping (Bool) -> Void) {
        //        self.showProgressBar()
        viewModel.getAttendanceListAPI { [self] (status,message)  in
            
            if status == true {
                self.hideProgressBar()
                breakDateArr.removeAll()
                startTimer()
                
                self.clockedOutTime()
                if viewModel.attendList.count == 1 {
                    finalBreakTIme = 0
                    viewModel.breakList = self.viewModel.attendList.filter { !$0.chekcIntype!.contains("CheckIn")  && !$0.chekcIntype!.contains("CheckOut")}
                    print(viewModel.breakList)
                    completionHandler(false)
                } else {
                    viewModel.breakList = self.viewModel.attendList.filter { !$0.chekcIntype!.contains("CheckIn")  && !$0.chekcIntype!.contains("CheckOut")}
                    print(viewModel.breakList)
                    
                    finalBreakTIme = 0

                    for i in 0..<viewModel.breakList.count {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let breakIn = dateFormatter.date(from:self.viewModel.breakList[i].date!)
                        self.breakDateArr.append(breakIn!)
                        print(breakDateArr)
                    }
                    
                    print(breakDateArr)
                    if breakDateArr.count%2 != 0 {
                        breakDateArr.removeLast()
                    }
                    newDateArr = breakDateArr.chunked(by: 2)
                    print(newDateArr)
                    finalBreakArr.removeAll()
                    
                    for inn in 0..<newDateArr.count {
                        var arr = [Date]()
                        arr.removeAll()
                        print(arr)
                        arr = newDateArr[inn]
                        print(arr)
                        if arr.count == 1 {
                            let diffComponentsss = Calendar.current.dateComponents([.second],from: arr[0])
                            print(diffComponentsss)
                            let timeeee = diffComponentsss.second
                            print(timeeee)
                            finalBreakArr.append(timeeee!)
                            print(finalBreakArr)
                        } else {
                            let diffComponentsss = Calendar.current.dateComponents([.second],from: arr[0], to: arr[1])
                            print(diffComponentsss)
                            let timeeee = diffComponentsss.second
                            print(timeeee)
                            finalBreakArr.append(timeeee!)
                            print(finalBreakArr)
                        }
                    }
                    
                    print(finalBreakArr)
                    let new = finalBreakArr.reduce(0, +)
                    finalBreakTIme = new
                    print("finalBreakTIme----->",finalBreakTIme)
                    
                    let hours = finalBreakTIme / 3600
                    let minutes = (finalBreakTIme % 3600) / 60
                    let seconds = (finalBreakTIme % 3600) % 60
                    
                    breakView.text = String(format: "%02d:%02d:%02d",hours, minutes, seconds)
                    AppConfig.breakTime = breakView.text
                    
                    if viewModel.breakList.count > 0 {
                        
                        if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "BreakIn" {
                            breakIn = true
                            view1.backgroundColor = UIColor.systemRed
                            breakImg.image = UIImage(named: "icon0")
                            
                            breakLbl.textColor = UIColor.white
                            breakLbl.text = "Stop Break"
                            completionHandler(true)
                        }
                        
                        if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "BreakOut" {
                            breakIn = false
                            view1.backgroundColor = .white
                            breakImg.image = UIImage(named: "icon1")
                            view1.backgroundColor = UIColor.white
                            breakLbl.textColor = UIColor.black
                            breakLbl.text = "Take Break"
                            completionHandler(false)
                        }
                        
                        if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "HomeBreakIn" {
                            breakIn = true
                            view1.backgroundColor = UIColor.systemRed
                            breakImg.image = UIImage(named: "icon0")
                            
                            breakLbl.textColor = UIColor.white
                            breakLbl.text = "Stop Break"
                            completionHandler(true)
                        }
                        
                        if viewModel.breakList[viewModel.breakList.count - 1].chekcIntype == "HomeBreakOut" {
                            breakIn = false
                            view1.backgroundColor = .white
                            view1.backgroundColor = UIColor.white
                            
                            breakImg.image = UIImage(named: "icon1")
                            breakLbl.textColor = UIColor.black
                            breakLbl.text = "Take Break"
                            completionHandler(false)
                        }
                    } else {
                        completionHandler(false)
                    }
                }
                //MARK:- TotalTime.......
                
                let arr = self.viewModel.attendList[0].date!.components(separatedBy: "T")
                let ar = arr[1].components(separatedBy: ":")
                
                self.clockedInTimeLbl.text = "Clocked In: \(ar[0]):\(ar[1])"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                let ss = dateFormatter.date(from:self.viewModel.attendList[0].date!)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let calendar = Calendar.current
                print(calendar)
                let arrrr = localDate()
                print(arrrr)
                
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                let reqDate = formatter.string(from: arrrr)
                let aa = formatter.date(from: reqDate)
                print(ss!)
                print(aa!)
                let diffComponents = Calendar.current.dateComponents([.hour, .minute,.second],from: ss!, to: aa!)
                print(diffComponents)
                totalTime = diffComponents.hour! * 3600 + diffComponents.minute! * 60 +  diffComponents.second!
                print(totalTime!)
            } else {
                self.showToast(message)
            }
        }
    }
    
    func clockedOutTime() {
        
        viewModel.clockedOutList = self.viewModel.attendList.filter { !$0.chekcIntype!.contains("BreakIn") || !$0.chekcIntype!.contains("BreakOut")}
        print(viewModel.clockedOutList)
       
        for i in 0..<viewModel.clockedOutList.count {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            let breakIn = dateFormatter.date(from:self.viewModel.attendList[i].date!)
            self.checkoutDateArr.append(breakIn!)
            print(checkoutDateArr)
        }
        
        print(checkoutDateArr)
        newCheckOutDateArr = checkoutDateArr.chunked(by: 2)
        print(newCheckOutDateArr)
        finalCheckOutArr.removeAll()
        
        for inn in 0..<finalCheckOutArr.count {
            var arr = [Date]()
            arr.removeAll()
            arr = newCheckOutDateArr[inn]
            
            if arr.count == 1 {
                let diffComponentsss = Calendar.current.dateComponents([.second],from: arr[0])
                print(diffComponentsss)
                let timeeee = diffComponentsss.second
                finalCheckOutArr.append(timeeee!)
                print(finalCheckOutArr)
            } else {
                let diffComponentsss = Calendar.current.dateComponents([.second],from: arr[0], to: arr[1])
                print(diffComponentsss)
                let timeeee = diffComponentsss.second
                finalCheckOutArr.append(timeeee!)
                print(finalCheckOutArr)
            }
        }
        
        print(finalCheckOutArr)
        let totalTimee = finalCheckOutArr.reduce(0, +)
        finalCheckoutTIme = totalTimee
        print(finalCheckoutTIme)
        let hours = finalCheckoutTIme / 3600
        let minutes = finalCheckoutTIme / 60 % 60
        let seconds = finalCheckoutTIme % 60
        
        let checkout = String(format: "%02d:%02d:%02d",hours, minutes, seconds)
        AppConfig.checkOutTime = checkout
    }
    
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
}

extension Array {
    
    func chunked(by distance: Int) -> [[Element]] {
        let indicesSequence = stride(from: startIndex, to: endIndex, by: distance)
        let array: [[Element]] = indicesSequence.map {
            let newIndex = $0.advanced(by: distance) > endIndex ? endIndex : $0.advanced(by: distance)
            //let newIndex = self.index($0, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex // also works
            return Array(self[$0 ..< newIndex])
        }
        return array
    }
    
}

extension TimeInterval {
    
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}
