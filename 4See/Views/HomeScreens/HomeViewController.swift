//
//  HomeViewController.swift
//  4See
//
//  Created by Gagan Arora on 03/03/21.
//

import UIKit
import SideMenu
import MarqueeLabel
import WebKit
import CoreLocation
import GoogleMaps

class HomeViewController: BaseViewController
{
    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var announcementsLbl: MarqueeLabel!
    @IBOutlet weak var marqueWebVW: WKWebView!
    @IBOutlet weak var clockedInbtn: UIButton!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var switchLbl: UILabel!
    @IBOutlet weak var clockedIn2: UIButton!
    @IBOutlet weak var workBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var sickBtn: UIButton!
    
    @IBOutlet weak var gpsSwitch: UISwitch!
    
    let viewModel = announcementViewModel()
    let vModel = attendanceViewModel()
    private let locationManager = CLLocationManager()
    var marker : GMSMarker!
    var map_view: GMSMapView!
    var current_latitude : CLLocationDegrees!
    var current_longitude : CLLocationDegrees!
    var company_lat : Double = 0.0
    var company_lng : Double = 0.0
    var homeViewModel = HomeViewModel()
    
    override class var storyboardIdentifier: String
    {
        return "HomeViewController"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gpsSwitch.setOn(false, animated: true)
        self.switchLbl.text = "GPS location is switched off"
        
        getAnnouncementsData()
        initSideMenuView()
        dataSetup()
        marqueWebVW.isOpaque = false
        marqueWebVW.layer.cornerRadius = 12
        marqueWebVW.clipsToBounds = true
        clockedInbtn.isHidden = true
        clockedIn2.isHidden = true
        
        marqueWebVW.backgroundColor = BaseColors.themeColor
        marqueWebVW.tintColor = BaseColors.themeColor
        self.showProgressBar()
        NotificationCenter.default.addObserver(self, selector : #selector(handleNotification(n:)), name : Notification.Name("notificationData"), object : nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGPSButton), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                gpsSwitch.setOn(false, animated: true)
                self.switchLbl.text = "GPS location is switched off"
                self.updateUserProfile()
            case .authorizedAlways, .authorizedWhenInUse:
                if let geoLocaton = UserDefaults.standard.value(forKey: "geoLocaton") as? String, geoLocaton == "off" {
                    gpsSwitch.setOn(false, animated: true)
                    self.switchLbl.text = "GPS location is switched off"
                    self.updateUserProfile()
                } else {
                    if UserDefaults.standard.value(forKey: "geoLocaton") as? String != nil {
                        gpsSwitch.setOn(true, animated: true)
                        self.switchLbl.text = "GPS location is switched on"
                        locationManager.delegate = self
                        locationManager.requestAlwaysAuthorization()
                        locationManager.startUpdatingLocation()
                        locationManager.activityType = .automotiveNavigation
                        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        locationManager.startMonitoringSignificantLocationChanges()
                    }
                }
            @unknown default:
                break
            }
        }
    }
    
    @objc func handleNotification(n : NSNotification) {
        let objc = messageVC()
        self.navigationController?.pushViewController(objc)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataSetup()
        getAttendanceListAPI()
    }
    
    @IBAction func actionGpsLocation(_ sender: UISwitch) {
        if !sender.isOn {
            gpsSwitch.setOn(true, animated: true)
            self.switchLbl.text = "GPS location is switched on"
            self.openSettings()
        } else {
            checkLocationPermissions()
        }
    }
    
    @objc func updateGPSButton() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                gpsSwitch.setOn(false, animated: true)
                self.switchLbl.text = "GPS location is switched off"
            case .authorizedAlways, .authorizedWhenInUse:
                gpsSwitch.setOn(true, animated: true)
                self.switchLbl.text = "GPS location is switched on"
                locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                locationManager.activityType = .automotiveNavigation
                locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startMonitoringSignificantLocationChanges()
            @unknown default:
                break
            }
        }
        updateUserProfile()
    }
    
    func checkLocationPermissions() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                gpsSwitch.setOn(false, animated: true)
                self.switchLbl.text = "GPS location is switched off"
                self.openSettings()
            case .authorizedAlways, .authorizedWhenInUse:
                gpsSwitch.setOn(true, animated: true)
                self.switchLbl.text = "GPS location is switched on"
                locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                locationManager.activityType = .automotiveNavigation
                locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startMonitoringSignificantLocationChanges()
            @unknown default:
                break
            }
        }
        updateUserProfile()
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    
    func dataSetup() {
        Global.getDataFromUserDefaults(.userData)
        nameLbl.text = "Welcome \(AppConfig.loggedInUser!.userInfo!.name!.firstCapitalized)"
        jobLbl.text = UserDefaults.standard.value(forKey: "jobTitle") as! String + " - " + AppConfig.loggedInUser!.userInfo!.department!
        let img = UserDefaults.standard.value(forKey: "image") as! String
        print(UrlConfig.IMAGE_URL+(img as! String))
        imgVW.setImageOnView(UrlConfig.IMAGE_URL+img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        logoImg.setImageOnView(UrlConfig.IMAGE_URL+AppConfig.loggedInUser!.userInfo!.companyId!.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    }
    
    //MARK:- IBActions()
    @IBAction func menuBtnAction(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func eventsAction(_ sender: Any) {
        let objc = announcementsViewController()
        self.navigationController?.pushViewController(objc)
    }
    
    @IBAction func editProfileBtnAction(_ sender: Any) {
        let objc = editProfileViewController()
        self.navigationController?.pushViewController(objc)
    }
    
    @IBAction func toolsBtnAction(_ sender: Any) {
        let objc = toolsTradeViewController()
        self.navigationController?.pushViewController(objc)
    }
    
    @IBAction func runningLateAction(_ sender: Any) {
        if self.vModel.attendList.count != 0
        {
            if  self.vModel.attendList[self.vModel.attendList.count - 1].chekcIntype == "CheckOut" ||  self.vModel.attendList[self.vModel.attendList.count - 1].chekcIntype == "HomeCheckOut"{
                self.showToast("You are unable to access this feature as you checkout for the day.")
            }
            else if  self.vModel.attendList[0].chekcIntype == "CheckIn" || self.vModel.attendList[0].chekcIntype == "HomeCheckIn"
            {
                self.showToast("You are unable to access this feature during clocked in.")
            }
//            else if  self.vModel.attendList[0].chekcIntype == "HomeCheckIn"
//            {
//                self.showToast("You are unable to access this feature during clocked in.")
//            }
            else
            {
                let vc = runningLateVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            let vc = runningLateVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func attendanceAction(_ sender: Any)
    {
        if self.vModel.attendList.count == 0
        {
            if !gpsSwitch.isOn {
                showToast("Please turn on the GPS switch first before moving further.")
            } else {
                let objc = biometricsVC()
                objc.type = "Attendance"
                GlobalVariable.dismiss = "other"
                self.navigationController?.pushViewController(objc)
            }
        }
        else
        {
            if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "CheckIn"
            {
                self.clockedInbtn.isHidden = false
                self.clockedIn2.isHidden = true
                let objc = TimeTrackingVC()
                objc.type = "Attendance"
                self.navigationController?.pushViewController(objc)
                
            }
            else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "BreakIn"
            {
                self.clockedInbtn.isHidden = false
                self.clockedIn2.isHidden = true
                let objc = TimeTrackingVC()
                objc.type = "Attendance"
                self.navigationController?.pushViewController(objc)
            }
            else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeCheckIn"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = false
                
                self.showToast("You are unable to clocked in more than once in a day")
            }
            else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeBreakIn"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = false
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "CheckOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "BreakOut"
            {
                self.clockedInbtn.isHidden = false
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                let objc = TimeTrackingVC()
                objc.type = "Attendance"
                self.navigationController?.pushViewController(objc)
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeCheckOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeBreakOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            
        }
        
        
    }
    
    @IBAction func wfhAction(_ sender: Any)
    {
        if self.vModel.attendList.count == 0
        {
            let objc = biometricsVC()
            objc.type = "Work From Home"
            GlobalVariable.dismiss = "other"
            self.navigationController?.pushViewController(objc)
        }
        else
        {
            if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "CheckIn"
            {
                self.clockedInbtn.isHidden = false
                self.clockedIn2.isHidden = true
                self.showToast("You are unable to clocked in more than once in a day")
                
                
            }
            else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "BreakIn"
            {
                self.clockedInbtn.isHidden = false
                self.clockedIn2.isHidden = true
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeCheckIn"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = false
                let objc = TimeTrackingVC()
                objc.type = "Work From Home"
                self.navigationController?.pushViewController(objc)
                
            }
            else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeBreakIn"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = false
                let objc = TimeTrackingVC()
                objc.type = "Work From Home"
                self.navigationController?.pushViewController(objc)
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "CheckOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "BreakOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeCheckOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = true
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                self.showToast("You are unable to clocked in more than once in a day")
                
            }
            else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeBreakOut"
            {
                self.clockedInbtn.isHidden = true
                self.clockedIn2.isHidden = false
                self.homeBtn.isUserInteractionEnabled = true
                self.workBtn.isUserInteractionEnabled = true
                let objc = TimeTrackingVC()
                objc.type = "Work From Home"
                self.navigationController?.pushViewController(objc)
            }
            
        }
        
    }
    @IBAction func sickAction(_ sender: Any)
    {
        if self.vModel.attendList.count != 0
        {
            if  self.vModel.attendList[self.vModel.attendList.count - 1].chekcIntype == "HomeCheckOut"
            {
                let objc = sickViewController()
                self.navigationController?.pushViewController(objc)
                
            }
            else if  self.vModel.attendList[self.vModel.attendList.count - 1].chekcIntype == "CheckOut"
            {
                let objc = sickViewController()
                self.navigationController?.pushViewController(objc)
                
            }
            else
            {
                self.showToast("You are unable to access this feature during clocked in.")
                
            }
        }
        else
        {
            let objc = sickViewController()
            self.navigationController?.pushViewController(objc)
        }
        
        
    }
    
    @IBAction func clockAction(_ sender: Any)
    {
        let objc = TimeTrackingVC()
        self.navigationController?.pushViewController(objc)
    }
    
    func openSettings() {
//        if (sender.isOn == true){
//            print("on")
//            gpsSwitch.setOn(true, animated: true)
//            switchLbl.text = "GPS location is switched on"
//            CLLocationManager.locationServicesEnabled()
        let alert = UIAlertController(title: "Setting", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settings app under Privacy, Location Services.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings now", style: .default, handler: { (alert: UIAlertAction!) in
            print("setting")
            if URL(string: UIApplication.openSettingsURLString) != nil {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            // }

        }))

        self.present(alert, animated: true, completion: nil)
//        }
//        else{
//            print("off")
//            switchLbl.text = "GPS location is switched off"
//            statusDeniedAlert()
//            gpsSwitch.setOn(false, animated: true)
//
//        }
    }
//    func statusDeniedAlert() {
//        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to disable  location  services, please open this app's settings and set location access to 'never'.", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Open Settings", style: .`default`, handler: { action in
//            if #available(iOS 10.0, *) {
//                let settingsURL = URL(string: UIApplication.openSettingsURLString)!
//                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//            } else {
//                if let url = NSURL(string:UIApplication.openSettingsURLString) {
//                    UIApplication.shared.openURL(url as URL)
//                }
//            }
//        }))
//        self.present(alertController, animated: true, completion: nil)
//    }
}
extension HomeViewController {
    
    func getAnnouncementsData() {
        viewModel.getAnnouncementsAPI { (status, message) in
            if status == true
            {
                let font = UIFont.init(name: "Roboto-Medium", size: 18)
                if self.viewModel.announcementsList?.data.count != 0
                {
                    let arr  = self.viewModel.announcementsList!.data[0].createdAt?.components(separatedBy: "T")
                    print(arr)
                    self.marqueWebVW.loadHTMLString("<html><body><marquee style='font-family:Roboto;color:white;padding:30px 30px 20px 30px;font-size:44px;'>\(arr![0]) \(String(describing: self.viewModel.announcementsList!.data[0].title!))</marquee></body></html>", baseURL: nil)
                }
                else
                {
                    self.marqueWebVW.loadHTMLString("<html><body><marquee style='font-family:\(font!.familyName);color:white;padding:30px 30px 20px 30px;font-size:44px;'> No annoucement found.</marquee></body></html>", baseURL: nil)
                }
            }
            else
            {
                self.showToast(message)
                if message == "User is logged in from another device."
                {
                    UserDefaults.standard.set(false, forKey: "USERISLOGIN")
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let initialVC = storyboard.instantiateInitialViewController()
                    UIApplication.shared.windows.first?.rootViewController = initialVC
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }

            }
        }
    }
    func getAttendanceListAPI() {
        vModel.getAttendanceListAPI {(status,message)  in
            if status == true
            {
                self.hideProgressBar()
                if self.vModel.attendList.count != 0
                {
                    if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "CheckIn"
                    {
                        self.clockedInbtn.isHidden = false
                        self.clockedIn2.isHidden = true
                        self.clockedInbtn.setTitle("Clocked In", for: .normal)

                    }
                    else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "BreakIn"
                    {
                        self.clockedInbtn.isHidden = false
                        self.clockedIn2.isHidden = true
                       
                    }else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeCheckIn"{
                        self.clockedInbtn.isHidden = true
                        self.clockedIn2.isHidden = false
                        }
                    else if  self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeBreakIn"{
                        self.clockedInbtn.isHidden = true
                        self.clockedIn2.isHidden = false
                        }
                    else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "CheckOut"
                    {
                        self.clockedInbtn.isHidden = true
                        self.clockedIn2.isHidden = true
                        self.homeBtn.isUserInteractionEnabled = true
                        self.workBtn.isUserInteractionEnabled = true
                        self.sickBtn.isUserInteractionEnabled = true

                    }
                    else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "BreakOut"
                    {
                        self.clockedInbtn.isHidden = false
                        self.clockedIn2.isHidden = true
                        self.homeBtn.isUserInteractionEnabled = true
                        self.workBtn.isUserInteractionEnabled = true

                    }
                    else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeCheckOut"
                    {
                        self.clockedInbtn.isHidden = true
                        self.clockedIn2.isHidden = true
                        self.homeBtn.isUserInteractionEnabled = true
                        self.workBtn.isUserInteractionEnabled = true

                    }
                    else if self.vModel.attendList[self.vModel.attendList.count-1].chekcIntype == "HomeBreakOut"
                    {
                        self.clockedInbtn.isHidden = true
                        self.clockedIn2.isHidden = false
                        self.homeBtn.isUserInteractionEnabled = true
                        self.workBtn.isUserInteractionEnabled = true

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

extension HomeViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedAlways) {
            //App Authorized, stablish geofence
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.activityType = .automotiveNavigation
            locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startMonitoringSignificantLocationChanges()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        locationManager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        current_latitude = userLocation.coordinate.latitude
        current_longitude = userLocation.coordinate.longitude
        let location = CLLocation.init(latitude: current_latitude, longitude: current_longitude)
        
        print(AppConfig.loggedInUser!.userInfo!.companyId!.location!.lat)
        print(AppConfig.loggedInUser!.userInfo!.companyId!.location!.lng)
        
        if AppConfig.loggedInUser!.userInfo!.companyId!.location!.lat == nil && AppConfig.loggedInUser!.userInfo!.companyId!.location!.lng == nil {
            company_lat = 30.639950
            company_lng = 76.814510
        } else {
            company_lat = (AppConfig.loggedInUser!.userInfo!.companyId!.location!.lat! as NSString).doubleValue
            company_lng = (AppConfig.loggedInUser!.userInfo!.companyId!.location!.lng! as NSString).doubleValue
        }
        
        let officeLocation = CLLocation.init(latitude: company_lat, longitude: company_lng)
        
        let geoFenceCenter = CLLocationCoordinate2DMake(company_lat,company_lng)
        let geofenceRegion = CLCircularRegion.init(center: geoFenceCenter, radius: min(100.0, locationManager.maximumRegionMonitoringDistance), identifier: "region")
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        locationManager.startMonitoring(for: geofenceRegion)
        print(location.distance(from: officeLocation))
        print(geofenceRegion.radius)
        print(location)
        print(officeLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Region: \(region.identifier)")
        manager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.showToast("You are enter in location.")
            workBtn.isUserInteractionEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.showToast("You are exit from location.")
            workBtn.isUserInteractionEnabled = false
        }
    }
}

extension HomeViewController {

    func updateUserProfile() {
        homeViewModel.setValues(gpsSwitch.isOn)
        homeViewModel.updateProfileAPI()
    }
    
}
