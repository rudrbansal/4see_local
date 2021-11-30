//
//  ExtensionsClasses.swift
//  4See
//
//  Created by Gagan Arora on 03/03/21.
//

import Foundation
import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }

        let selection = selectedTextRange

        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)

        selectedTextRange = selection
    }
    
    func setPlaceholder(_ placeHolder:String,withColor color:UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension Int {
    
    var boolValue: Bool { return self != 0 }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        return localDate
    }
    
    func getdates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func getDateMMMMDDString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMMM, dd"
        return dateFormatterGet.string(from: self)
    }
    
    func getDateddMMMYYYYString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd MMMM YYYY"
        return dateFormatterGet.string(from: self)
    }
    
    func getDateYYYYMMDDString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.string(from: self)
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return dateFormatter.string(from: Date())
    }
    
    func convertToMilli(timeIntervalSince1970: TimeInterval) -> Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
    
    func convertMilliToDate(milliseconds: Int64) -> Date {
        return Date(timeIntervalSince1970: (TimeInterval(milliseconds) / 1000))
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func startOfWeek() -> Date {
        let interval = Calendar.current.dateInterval(of: .weekOfMonth, for: self)
        return (interval?.start.toLocalTime())! // Without toLocalTime it give last months last date
    }
    
    func endOfWeek() -> Date {
        let interval = Calendar.current.dateInterval(of: .weekOfMonth, for: self)
        return interval!.end
    }
    
    static func getMonthAndYearBetween(from start: Date, to end: Date) -> [Date] {
        var allDates: [Date] = []
        guard start < end else { return allDates }
        
        let calendar = Calendar.current
        let month = calendar.dateComponents([.month], from: start, to: end).month ?? 0
        
        for i in 0...month {
            if let date = calendar.date(byAdding: .month, value: i, to: start) {
                allDates.append(date)
            }
        }
        allDates.append(end)
        return allDates
    }
    
}

extension String {
    
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
    func epoch(dateFormat: String = "yyyy-MM-ddTHH:mm:ss.sssZ", timeZone: String? = nil) -> TimeInterval? {
       // building the formatter
       let formatter = DateFormatter()
       formatter.dateFormat = dateFormat
       if let timeZone = timeZone { formatter.timeZone = TimeZone(identifier: timeZone) }

       // extracting the epoch
       let date = formatter.date(from: self)
       return date?.timeIntervalSince1970
     }
    func getDate() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.date(from: self) ?? Date()
    }
    func gettDate() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-ddTHH:mm:ss.sssZ"
        return dateFormatterGet.date(from: self) ?? Date()
    }
    func getTTime() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        return dateFormatterGet.date(from: self) ?? Date()
    }
    func getScheduleVisitDate() -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        let getDate = dateFormatterGet.date(from: self) ?? Date()
       
        if Calendar.current.compare(getDate, to: Date(), toGranularity: .day) == .orderedSame {
            return "Today"
        }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        return dateFormatterPrint.string(from: getDate)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
                   
}

extension Optional {
    
    func optionalValue() -> String {
        switch(self) {
        case .none:
            return ""
        case .some(let value):
            return value as! String
        }
    }
}

extension Double {
    
    func formatTrailing() -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UITableView {
    
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
}

extension Array where Element:Equatable {
    
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
   
    func createBorderDashLine() {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(border)
    }
}

