//
//  attendanceVC.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu
import DropDown

enum attend_Type {
    case week
    case month
}

class attendanceVC: BaseViewController {
    
    @IBOutlet weak var attendancetable: UITableView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var arrowImg: UIImageView!
    
    let viewModel = attendanceViewModel()
    let dropDown = DropDown()
    var status = 1
    var futureDate: Date!
    var currentMonth = ""
    var year = Calendar.current.component(.year, from: Date())
    var monthh = Calendar.current.component(.month, from: Date())
    var allDays = NSArray()
    var allDates = [String]()
    var regDates = [String]()
    var filterDates = [String]()
    var attendanceType: attend_Type = .week
    var dateStr = ""
    var mInt:Int!
    var mm = [String]()
    var mutableArr = NSMutableArray()
    var positions = 0
    var daysPosss = 0
    var weekDays = [String]()
    var newArr = [String]()
    var finalFilteredList = [RegisterModel]()
    
    override class var storyboardIdentifier: String {
        return "attendanceVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendancetable.register(nibWithCellClass: attendanceCell.self)
        
        allDates.removeAll()
        arrowImg.isHidden = true
    }
    
    fileprivate func setupDropDownUI() {
        if attendanceType == .week {
            arrowImg.isHidden = true
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let currentDate = formatter.string(from: Date())
            let month = convertMonth(date: currentDate)
            
            status = 0
            currentMonth = month
            var startDate = Date().startOfWeek().startOfDay
            let endDate = Date()
            
            if let createdDate = AppConfig.loggedInUser?.userInfo?.createdDate, startDate < createdDate {
                startDate = createdDate.startOfDay
            }
            let start1 = String(describing: startDate).components(separatedBy: "-")
            let endDate1 = endDate.dateString("dd MMMM YYYY")
            let newStart1 = start1[2].components(separatedBy: " ")
            
            dateBtn.isUserInteractionEnabled = false
            allDates.removeAll()
            attendancetable.reloadData()
            
            self.dateBtn.setTitle(newStart1[0] + " - " + endDate1, for: .normal)
            if startDate == Date().startOfDay {
                self.dateBtn.setTitle(endDate1, for: .normal)
            }
            
            self.viewModel.setfilterAttendanceValues(String(describing: startDate.toLocalTime()), String(describing: Date().endOfDay.toLocalTime()))
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd"
            
            let count = printCountBtnTwoDates(mStartDate: startDate, mEndDate: Date())
            print(count)
//            let date = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())
            allDays = Date.dates(from: startDate, to: Date().endOfDay) as NSArray
            for i in 0..<allDays.count {
                allDates.append(dformatter.string(from: allDays[i] as! Date))
            }
            allDates = allDates.removeDuplicates()
            status = 1
            self.filterAttendanceAPi()
            self.attendancetable.reloadData()
        } else {
            arrowImg.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let currentDate = formatter.string(from: Date())
            var startOfMonth = Date().startOfMonth().startOfDay
            if let createdDate = AppConfig.loggedInUser?.userInfo?.createdDate, startOfMonth < createdDate {
                startOfMonth = createdDate.startOfDay
            }
            let endOfMonth = Date().endOfDay
            let start = formatter.string(from: startOfMonth)
            let end = formatter.string(from: endOfMonth)

            let month = convertMonth(date: currentDate)
            status = 0
            currentMonth = month
            self.dateBtn.setTitle(month, for: .normal)
            
            dateBtn.isUserInteractionEnabled = true
            self.viewModel.setfilterAttendanceValues(start, end)
            self.calculateDays(month: month,"yyyy-MM-dd")
            self.filterAttendanceAPi()
            self.attendancetable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        holidayListAPi()
//        setupDropDownUI()
    }
    
    func dropDownData() {
        dropDown.anchorView = dateBtn
        dropDown.tintColor  = BaseColors.themeColor
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let createdDate = AppConfig.loggedInUser?.userInfo?.createdDate {
            
            let monthDates = Date.getMonthAndYearBetween(from: createdDate, to: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let monthArray = (monthDates.map { dateFormatter.string(from: $0) }).removeDuplicates()
            dropDown.dataSource = monthArray.reversed()
        }
        
        dropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
    }
    
    //MARK:- SideMenu Function
    
    func initSideMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    
    func printCountBtnTwoDates(mStartDate: Date, mEndDate: Date) -> Int {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        var newDate = mStartDate
        weekDays.removeAll()
        
        while newDate <= mEndDate {
            formatter.dateFormat = "yyyy-MM-dd"
            weekDays.append(formatter.string(from: newDate))
            newDate = calendar.date(byAdding: .day, value: 1, to: newDate)!
        }
        return weekDays.count
    }
    
    @IBAction func dateAction(_ sender: Any) {
        
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            self.dateBtn.setTitle(item, for: .normal)
            
            self.currentMonth = item
            var startDatee = "\(self.year)-\(item)-01"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MMM-dd"
            
            let startMonthDate = formatter.date(from: startDatee)
           
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yyyy-MMMM-dd"
            
            if let createdDate = AppConfig.loggedInUser?.userInfo?.createdDate, (startMonthDate ?? Date()) < createdDate {
                startDatee = formatter1.string(from: createdDate) + " 00:00:00 +0000"
            } else {
                startDatee = startDatee + " 00:00:00 +0000"
            }
            
            let daysInMonth = self.getDaysInMonth(startMonthDate ?? Date())
            var endDatee = "\(self.year)-\(item)-\(daysInMonth)"
            
            if let endMonthDate = formatter.date(from: endDatee), Date() < endMonthDate {
                endDatee = formatter1.string(from: Date()) + " 23:59:59 +0000"
            } else {
                endDatee = endDatee + " 23:59:59 +0000"
            }
            
            self.viewModel.setfilterAttendanceValues(startDatee, endDatee)
            self.filterAttendanceAPi()
            self.dropDown.hide()
            self.calculateDays(month: item,"yyyy-MMMM-dd")
            self.attendancetable.reloadData()
            
        }
    }
    
    func getDaysInMonth(_ date:Date) -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController()
    }
    
    @IBAction func menuAction(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 1:
            print("Week Action")
            attendanceType = .week
        case 2:
            attendanceType = .month
        default:
            print("no")
        }
        setupDropDownUI()
    }
    
    func calculateDays(month:String,_ format:String) {
        let calendar = NSCalendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = format
        var startDatee = formatter.date(from: "\(year)-\(month)-01")
        
        let numberOfDays = calendar.range(of: .day, in: .month, for: startDatee!)
        allDates.removeAll()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        if let date = AppConfig.loggedInUser?.userInfo?.createdDate {
            if (startDatee ?? Date()) < date {
                startDatee = date.startOfDay
            }
        }
        
        if let numberOfDay = numberOfDays?.count {
            var endDatee = "\(self.year)-\(month)-\(numberOfDay)"
            
            if let endMonthDate = formatter.date(from: endDatee), Date() < endMonthDate {
                endDatee = formatter.string(from: Date().endOfDay)
            }
            
            allDays = Date.dates(from: startDatee!, to:formatter.date(from: endDatee)!) as NSArray
        }
        
        for i in 0..<allDays.count {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            allDates.append(dateFormatter.string(from: allDays[i] as! Date))
        }
        allDates = allDates.removeDuplicates()
        
    }
    
    func calculateAbsent() {
        let arr = allDates.removeDuplicates()
        viewModel.regFilterList.removeAll()
        if viewModel.regList.count != 0 {
            arr.forEach { (date) in
                let regList = viewModel.regList.filter { (registerModel) -> Bool in
                    return registerModel._id?.date == date
                }
                if regList.count > 0 {
                    viewModel.regFilterList.append(regList.first!)
                } else {
                    let holidaysList = viewModel.holidaysList.filter { registerModel -> Bool in
                        return registerModel.date == date
                    }
                    if holidaysList.count > 0 {
                        let holiday = RegisterModel(_id: idInfo(date: holidaysList.first?.date, email: "", name: ""), reason: "", userId: "", message: "", location: locnInfo(lat: 0.0, lng: 0.0), updatedAt: holidaysList.first?.updatedAt, date: holidaysList.first?.date, type: "2")
                        viewModel.regFilterList.append(holiday)
                    } else {
                        viewModel.regFilterList.append(RegisterModel.init(_id: idInfo.init(date: date, email: "", name: ""), reason: "", userId: "", message: "", location: locnInfo.init(lat: 0.0, lng: 0.0), updatedAt: "", date: date, type: ""))
                    }
                }
            }
            viewModel.regNewFilterList = viewModel.regFilterList
        } else {
            viewModel.regFilterList.removeAll()
            for inn in 0..<arr.count {
                let holidaysList = viewModel.holidaysList.filter { registerModel -> Bool in
                    return registerModel.date == arr[inn]
                }
                if holidaysList.count > 0 {
                    let holiday = RegisterModel(_id: idInfo(date: holidaysList.first?.date, email: "", name: ""), reason: "", userId: "", message: "", location: locnInfo(lat: 0.0, lng: 0.0), updatedAt: holidaysList.first?.updatedAt, date: holidaysList.first?.date, type: "2")
                    viewModel.regFilterList.append(holiday)
                } else {
                    viewModel.regFilterList.append(RegisterModel.init(_id: idInfo.init(date: "", email: "", name: ""), reason: "", userId: "", message: "", location: locnInfo.init(lat: 0.0, lng: 0.0), updatedAt: "", date: arr[inn], type: ""))
                }
                
            }
            viewModel.regNewFilterList = viewModel.regFilterList
        }
        
        attendancetable.reloadData()
    }
}

extension attendanceVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.regNewFilterList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withClass: attendanceCell.self)
        cell.cellModel = viewModel.regNewFilterList[indexPath.row]
        cell.ButtonViewClicked = {
            let objc = newaRegisterVCViewController()
            objc.startDate = self.viewModel.regNewFilterList[indexPath.row].date!
            AppConfig.breakTime = "00:00:00"
            objc.date = cell.dateLbl.text!
            objc.comeFrom = "register"
            self.navigationController?.pushViewController(objc)
        }
        cell.configureShadow()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
}

extension attendanceVC {
    
    func filterAttendanceAPi() {
        self.showProgressBar()
        viewModel.addFilterAttendApi { (status,message)  in
            if status == true {
                self.hideProgressBar()
                self.attendancetable.reloadData()
                self.attendancetable.delegate = self
                self.attendancetable.dataSource = self
                self.viewModel.monthArr.removeAll()
                self.calculateAbsent()
                self.dropDownData()
            } else {
                self.hideProgressBar()
            }
            self.attendancetable.reloadData()
        }
    }
    
    func removeDuplicateElements(post: [RegisterModel]) -> [RegisterModel] {
        var uniqueDates = [RegisterModel]()
        for date in viewModel.regFilterList {
            if !uniqueDates.contains(where: {$0.date! == date.date! }) {
                uniqueDates.append(date)
            }
        }
        return uniqueDates
    }
    
    func holidayListAPi() {
        self.showProgressBar()
        viewModel.getListHolidaysDetails(completion: { status, message in
            self.hideProgressBar()
            self.setupDropDownUI()
        })
    }
    
}

extension Array {
    
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
    
    func removingDuplicates<T: Equatable>(byKey key: KeyPath<Element, T>)  -> [Element] {
        var result = [Element]()
        var seen = [T]()
        for value in self {
            let key = value[keyPath: key]
            if !seen.contains(key) {
                seen.append(key)
                result.append(value)
            }
        }
        return result
    }
}


