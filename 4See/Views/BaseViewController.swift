//
//  BaseViewController.swift
//  4See
//
//  Created by Gagan Arora on 03/03/21.
//


import UIKit
import SwifterSwift
import SwiftValidator
import Toast_Swift
import SDWebImage
import NVActivityIndicatorView
import ActionSheetPicker_3_0
import Gradients
import NotificationBannerSwift

enum UserDefaultsKey:String {
    case userData
    case authToken
    case reminderData
    case taskData

}

class Global {
    
    static func userLogOut() {
        UserDefaults.standard.set(false, forKey: "USERISLOGIN")
        Global.removeDataFromUserDefaults(.userData)
        Global.removeDataFromUserDefaults(.authToken)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateInitialViewController()
        UIApplication.shared.windows.first?.rootViewController = initialVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    static func userLogIn()
    {
        let objLogin = HomeViewController()
        UIApplication.shared.windows.first?.rootViewController = objLogin
        UIApplication.shared.windows.first?.makeKeyAndVisible()
      
    }
    static func saveDataInUserDefaults(_ key:UserDefaultsKey) {
        do {
            if key == .userData {
                let jsonData = try JSONEncoder().encode(AppConfig.loggedInUser)
                let jsonString = String(decoding:jsonData, as: UTF8.self)
                UserDefaults.standard.set(jsonString, forKey: key.rawValue)
            }
        }
        catch {
            // handle error
            print("Unable to parse json")
        }
        
    }

    static func getDataFromUserDefaults(_ key:UserDefaultsKey) {
        if let jsonString = UserDefaults.standard.value(forKey: key.rawValue) as? String {
            let jsonData = jsonString.data(using: .utf8)!
            if key == .userData {
                AppConfig.loggedInUser = try? JSONDecoder().decode(UserModel.self, from: jsonData)
            }
        }
    }
   
    static func deleteDataFromUserDefaults(_ key:UserDefaultsKey) {
        if key == .userData {
            AppConfig.loggedInUser?.userInfo = nil
        }
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    static func removeDataFromUserDefaults(_ key:UserDefaultsKey) {
        if key == .userData {
            AppConfig.loggedInUser = nil
        }
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
   
static func getTopMostViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        
        return base
        
    }
}
struct BaseConstant {
    static var ImageTitleKey = "Please select image"
    static var CameraKey = "Camera"
    static var GalleryKey = "Gallery"
    static var CancelKey = "Cancel"
    static var ColorKey = "Select Color"
}

class BaseViewController: UIViewController,NVActivityIndicatorViewable {

    class var storyboardName: String {
        fatalError("Child Should Override")
    }

    class var storyboardIdentifier: String {
        fatalError("Child Should Override")
    }

    /**
        For the sub classes to use this method, the sub class is required to override the above two class varialbes, named 'storyboardName' and 'storyboardIdentifier', which are used by this method, to instantiate the view controller from the specified storyboard.
     */
    class func instance(embedIntoNavVc: Bool = true) -> UIViewController {
        let controller = UIStoryboard(name: self.storyboardName, bundle: nil).instantiateViewController(withIdentifier: self.storyboardIdentifier)
        if embedIntoNavVc {
            let nav = UINavigationController(rootViewController: controller)
            nav.navigationBar.isTranslucent = false
            nav.isNavigationBarHidden = true
            return nav
        } else {
            return controller
        }
    }
    static var PopupxColor : UIColor {
        return BaseColors.whiteColor
    }
    typealias ImageAPICallback = (UIImage?) -> Void
    var imageCompletion : ImageAPICallback?
    
    var appGrayColor : UIColor {
        return UIColor.lightGray
    }
    class CustomBannerColors: BannerColorsProtocol {

        internal func color(for style: BannerStyle) -> UIColor {
            return BaseViewController.PopupxColor
        }

    }
    
    var themeColor : UIColor {
        return Color.init(red: 100, green: 43, blue: 249)!
    }

    var validator = Validator()
    
    let imageController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setTitleFont(UIFont.systemFont(ofSize: 20.0), color: Color.white)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

//        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "backTheme").original
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backTheme").original
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
    }
    func gradientViewSetup(view: UIView) {
        
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        let gradientLayer = Gradients.linear(to: Direction.right, colors: [BaseColors.themeColor.cgColor,Color.init(red: 41, green: 144, blue: 205)!.cgColor], locations: [0.0,1.0])
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
   
    func removeGradientFromBackground (view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        let gradientLayer = Gradients.linear(to: Direction.right, colors: [BaseColors.whiteColor.cgColor,BaseColors.whiteColor.cgColor], locations: [0.0,1.0])
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.layer.insertSublayer (gradientLayer, at: 0)
        view.layer.sublayers = nil
        
    }

    func textfieldSetup(textField: UITextField, placeholder:String) {
        let bottomLine = UIView()
        bottomLine.frame =  CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = themeColor
        textField.placeholder = placeholder
        textField.addSubview(bottomLine)
    }
    
    func textFieldSecure(textField: UITextField) {
        textField.isSecureTextEntry.toggle()
    }
    
    func buttonSetup(button: UIButton) {
        button.layer.cornerRadius = button.frame.height/2
        button.layer.masksToBounds = true
        button.backgroundColor = themeColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
    }
    func alert(view: UIViewController, title: String, message: String? = nil, handler: (()->Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            handler?()
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }
  
    func setBackgroundImageOnView() {
        let imageView = UIImageView.init(frame: UIScreen.main.bounds)
        imageView.image = #imageLiteral(resourceName: "bgSplash")
        self.view.insertSubview(imageView, at: 0)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getTopMostViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        
        return base
        
    }
    
    func showProgressBar() {
        DispatchQueue.main.async {
            let size = CGSize(width: 40.0,
                              height: 40.0)
            let tint = Color(hexString: "#090742")?.withAlphaComponent(1.0)
            let background = Color(hexString: "#FFFFFF")?.withAlphaComponent(0.3)

            self.startAnimating(size, type: .ballClipRotateMultiple, color: tint, backgroundColor: background)
        }
    }
    
    func hideProgressBar() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
    
    func showToast(_ message: String) {
//        self.view.makeToast(message)
        let banner = NotificationBanner(title: message, style: .warning, colors: CustomBannerColors())
        banner.titleLabel?.textAlignment = .center
        banner.titleLabel?.font = UIFont.init(name: "Roboto", size: 16.0)
        banner.titleLabel?.font = .boldSystemFont(ofSize: 15.0)
        banner.titleLabel?.textColor = BaseColors.themeColor
        banner.haptic = .medium
        banner.duration = 2.0
        banner.dismissOnTap = true
        banner.dismissOnSwipeUp = true
        banner.show()
    }
    
    func openImagePopUp(completion: @escaping ImageAPICallback) {
        
        imageController.delegate = self
        self.imageCompletion = completion
        
        let actionSheetController: UIAlertController = UIAlertController(title: BaseConstant.ImageTitleKey, message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: BaseConstant.CancelKey, style: .cancel) { _ in
            print("Cancel")
        }
        
        actionSheetController.addAction(cancelActionButton)
        
        let cameraActionButton = UIAlertAction(title: BaseConstant.CameraKey, style: .default)
        { _ in
            self.imageController.sourceType = UIImagePickerController.SourceType.camera
            self.imageController.mediaTypes = ["public.image"]
            self.imageController.allowsEditing = true
            self.present(self.imageController, animated: true, completion: nil)
        }
        
        actionSheetController.addAction(cameraActionButton)
        
        let galleryActionButton = UIAlertAction(title: BaseConstant.GalleryKey, style: .default)
        { _ in
            self.imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imageController.mediaTypes = ["public.image"]
            self.imageController.allowsEditing = true
            self.present(self.imageController, animated: true, completion: nil)
        }
        
        actionSheetController.addAction(galleryActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func createDateStamp(dateFromBackEnd:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateFromBackEnd)
        formatter.dateFormat = "yyyy-MM-dd"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    func createTrackingStamp(dateFromBackEnd:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateFromBackEnd)
        formatter.dateFormat = "dd MMMM YYYY"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    func convertMonth(date:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: date)
        formatter.dateFormat = "MMMM"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    func getTime(dateFromBackEnd:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSZ"
        let date = formatter.date(from: dateFromBackEnd)
        formatter.dateFormat = "HH:mm a"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    func uploadDateFormat(dateFromBackEnd:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateFromBackEnd)
        formatter.dateFormat = "yyyy-MM-dd"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.openURL(phoneURL as URL)
              }))
      
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
            self.present(alert, animated: true, completion: nil)
        }
    }
   
}

extension UIView {

    func dropShadow() {
        self.layer.sublayers?.first(where: { $0.accessibilityLabel == "shadowLayer" })?.removeFromSuperlayer()
        
        let shadowLayer = CALayer()
        shadowLayer.accessibilityLabel = "shadowLayer"
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.systemGray6.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 2
        layer.masksToBounds = false
        layer.insertSublayer(shadowLayer, at: 0)
    }
}



extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" + " " + "ago" :
                "\(year)" + " " + "years" + " " + "ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" + " " + "ago" :
                "\(month)" + " " + "months" + " " + "ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" + " " + "ago" :
                "\(day)" + " " + "days" + " " + "ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" + " " + "ago" :
                "\(hour)" + " " + "hours" + " " + "ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" + " " + "ago" :
                "\(minute)" + " " + "minutes" + " " + "ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" + " " + "ago" :
                "\(second)" + " " + "seconds" + " " + "ago"
        } else {
            return "a moment ago"
        }
        
    }
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension BaseViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageCompletion?(pickedImage)
        }

        dismiss(animated: true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIImageView {
    
    func setImageOnView(_ imageUrlStr: String?) {
        if let imageStr = imageUrlStr, !imageStr.isEmpty, let imageUrl = URL(string: imageStr) {
            self.sd_setImage(with: imageUrl, placeholderImage: AppConfig.placeHolder, options: SDWebImageOptions.init(rawValue: 0), progress: nil, completed: nil)
        }
    }
    
    func toBase64()  -> String {
        let imageData:NSData = image!.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}


public extension Sequence {

    public func uniq<Id: Hashable >(by getIdentifier: (Iterator.Element) -> Id) -> [Iterator.Element] {
        var ids = Set<Id>()
        return self.reduce([]) { uniqueElements, element in
            if ids.insert(getIdentifier(element)).inserted {
                return uniqueElements + CollectionOfOne(element)
            }
            return uniqueElements
        }
    }


   public func uniq<Id: Hashable >(by keyPath: KeyPath<Iterator.Element, Id>) -> [Iterator.Element] {
      return self.uniq(by: { $0[keyPath: keyPath] })
   }
}

public extension Sequence where Iterator.Element: Hashable {

    var uniq: [Iterator.Element] {
        return self.uniq(by: { (element) -> Iterator.Element in
            return element
        })
    }

}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
extension BaseViewController {
    func datePickerTapped(completionHandler: @escaping ((String)->Void)) {
        
        let cancelButton:UIButton =  UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 55, height: 25)
        
        let doneButton:UIButton =  UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.frame = CGRect(x: 0, y: 0, width: 55, height: 25)
        let picker = ActionSheetDatePicker.init(title: "Select Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (picker, selectedIndex, selectedValue) in
            
            if let date = selectedIndex as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                completionHandler(formatter.string(from: date))
            }
        }, cancel: { (picker) in
            
        }, origin: Global.getTopMostViewController()?.view)

        picker?.toolbarButtonsColor = .black
        picker?.toolbarBackgroundColor = UIColor.white
        picker?.setCancelButton(UIBarButtonItem(customView: cancelButton))
        picker?.setDoneButton(UIBarButtonItem(customView: doneButton))
        
        picker?.show()
        
        if let datePicker = picker?.pickerView as? UIDatePicker {
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            }
        }
    }
}
