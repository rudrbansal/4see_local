//
//  sickViewController.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu

class sickViewController: BaseViewController,UITextViewDelegate
{
    override class var storyboardIdentifier: String
    {
        return "sickViewController"
    }
    @IBOutlet weak var submitVW: UIView!
    @IBOutlet weak var archiveVW: UIView!
    @IBOutlet weak var imgsCollection: UICollectionView!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var scVW: UIView!
    @IBOutlet weak var scrolll: UIScrollView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var archivebtn: UIButton!
    @IBOutlet weak var dateLbl: UITextField!
    @IBOutlet weak var reasonTFT: UITextField!
    @IBOutlet weak var daysTFT: UITextField!
    @IBOutlet weak var ifCovidBtn: UIButton!
    @IBOutlet weak var ifOtherCovidBtn: UIButton!
    @IBOutlet weak var notsTxtVW: UITextView!
    @IBOutlet weak var archiveTable: UITableView!
    let viewModel = SickViewModel()
    var isCovid = "0"
    var covideNot = "0"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        notsTxtVW.delegate = self
        reasonTFT.setPlaceholder("Reason:", withColor: BaseColors.themeColor)
        dateLbl.setPlaceholder("Select Date:", withColor: BaseColors.themeColor)
        heightConstant.constant = 0
        GlobalVariable.sickType = "Submit"
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        reset()

    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        ifCovidBtn.setBackgroundImage(UIImage(named: "sick_uncheck"), for: .normal)
        ifOtherCovidBtn.setBackgroundImage(UIImage(named: "sick_uncheck"), for: .normal)
        notsTxtVW.text = "Message/Notes:"
        notsTxtVW.textColor = BaseColors.themeColor
        submitVW.isHidden = false
        archiveVW.isHidden = true
    }
    private func configureTableView() {
        imgsCollection.delegate = self
        imgsCollection.dataSource = self
        archiveTable.register(nibWithCellClass: archiveCell.self)
        imgsCollection.register(nibWithCellClass: docCell.self)

    }
    func reset()
    {
       if  GlobalVariable.sickType == "Submit"
        {
        submitVW.isHidden = false
        archiveVW.isHidden = true
        submitBtn.backgroundColor = BaseColors.themeColor
        submitBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
        archivebtn.layer.borderWidth = 1
        archivebtn.borderColor = BaseColors.themeColor
        archivebtn.clipsToBounds = true
        archivebtn.backgroundColor = BaseColors.whiteColor
        archivebtn.setTitleColor(BaseColors.themeColor, for: .normal)
        }
    else if GlobalVariable.sickType == "Archive"
       {
            resetData()
            getLeavesData()
            archivebtn.backgroundColor = BaseColors.themeColor
            archivebtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            submitBtn.layer.borderWidth = 1
            submitBtn.borderColor = BaseColors.themeColor
            submitBtn.clipsToBounds = true
            submitBtn.backgroundColor = BaseColors.whiteColor
            submitBtn.setTitleColor(BaseColors.themeColor, for: .normal)
            submitVW.isHidden = true
            archiveVW.isHidden = false
       }
    else
    {
        submitVW.isHidden = false
        archiveVW.isHidden = true
        submitBtn.backgroundColor = BaseColors.themeColor
        submitBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
        archivebtn.layer.borderWidth = 1
        archivebtn.borderColor = BaseColors.themeColor
        archivebtn.clipsToBounds = true
        archivebtn.backgroundColor = BaseColors.whiteColor
        archivebtn.setTitleColor(BaseColors.themeColor, for: .normal)
    }
    }
    func resetData()
    {
        reasonTFT.text = ""
        daysTFT.text = ""
        ifCovidBtn.setBackgroundImage(UIImage(named: "sick_uncheck"), for: .normal)
        ifOtherCovidBtn.setBackgroundImage(UIImage(named: "sick_uncheck"), for: .normal)
        viewModel.attachments = []
        imgsCollection.reloadData()
        notsTxtVW.text = "Message/Notes:"
        heightConstant.constant = 0

    }

    @IBAction func back(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func covidCheckAction(_ sender: Any)
    {
        switch (sender as AnyObject).tag{
        case 1:
            if ifCovidBtn.backgroundImage(for: .normal) == UIImage(named: "sick_uncheck")
            {
                ifCovidBtn.setBackgroundImage(UIImage(named: "sick_check"), for: .normal)
                isCovid = "1"
            }
            else
            {
                ifCovidBtn.setBackgroundImage(UIImage(named: "sick_uncheck"), for: .normal)
                isCovid = "0"
            }

        case 2:
            if ifOtherCovidBtn.backgroundImage(for: .normal) == UIImage(named: "sick_uncheck")
            {
                ifOtherCovidBtn.setBackgroundImage(UIImage(named: "sick_check"), for: .normal)
                covideNot = "1"
            }
            else
            {
                ifOtherCovidBtn.setBackgroundImage(UIImage(named: "sick_uncheck"), for: .normal)
                covideNot = "0"

            }
        default:
            print("no")
        }
    }
    @IBAction func submitAction(_ sender: Any)
    {
        switch (sender as AnyObject).tag{
        case 1:
            submitVW.isHidden = false
            archiveVW.isHidden = true
            submitBtn.backgroundColor = BaseColors.themeColor
            submitBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            archivebtn.layer.borderWidth = 1
            archivebtn.borderColor = BaseColors.themeColor
            archivebtn.clipsToBounds = true
            archivebtn.backgroundColor = BaseColors.whiteColor
            archivebtn.setTitleColor(BaseColors.themeColor, for: .normal)
            GlobalVariable.sickType = "Submit"
        case 2:
            resetData()
            getLeavesData()
            archivebtn.backgroundColor = BaseColors.themeColor
            archivebtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            submitBtn.layer.borderWidth = 1
            submitBtn.borderColor = BaseColors.themeColor
            submitBtn.clipsToBounds = true
            submitBtn.backgroundColor = BaseColors.whiteColor
            submitBtn.setTitleColor(BaseColors.themeColor, for: .normal)
            submitVW.isHidden = true
            archiveVW.isHidden = false
            GlobalVariable.sickType = "Archive"

        default:
            print("no")
        }
     
    }
    
    @IBAction func datePickerAction(_ sender: Any)
    {
        self.datePickerTapped { (dateString) in
            self.dateLbl.text = dateString
        }
    }
    @IBAction func scanDocAction(_ sender: Any)
    {
        self.openImagePopUp { (pickerImage) in
            if let image = pickerImage {
                self.viewModel.attachments.append(image)
                self.heightConstant.constant = 150
                self.imgsCollection.reloadData()
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any)
    {
        var notes  = ""
        if notsTxtVW.text == "Message/Notes:"{
            notes = ""
        }else{
            notes = notsTxtVW.text
        }
       if reasonTFT.text == "" && dateLbl.text == "" && daysTFT.text == ""
        {
            showToast("All fields are required.")
        }
        else if reasonTFT.text == ""
        {
            showToast("Reason field is required.")
        }
        else if dateLbl.text == ""
        {
            showToast("Date field is required.")

        }
        else if daysTFT.text == ""
        {
            showToast("Please enter number of days.")

        }
        else
        {
            viewModel.setApplyLeaveValues(dateLbl.text!,reasonTFT.text!,notes,daysTFT.text!, isCovid, covideNot)
            applySickLeaveAPI()
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notsTxtVW.textColor == BaseColors.themeColor {
            notsTxtVW.text = nil
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if notsTxtVW.text.isEmpty {
            notsTxtVW.text = "Message/Notes:"
            notsTxtVW.textColor = BaseColors.themeColor
        }
       
    }
}
extension sickViewController: UITableViewDelegate,UITableViewDataSource
{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.leavesList!.data!.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withClass: archiveCell.self)
        cell.cellModel = viewModel.leavesList!.data![indexPath.row]
        cell.viewButtonClicked = {
            let objc = sick_announceViewController()
            objc.viewModel.selectedLeaveInfo = self.viewModel.leavesList!.data![indexPath.row]
            objc.type = GlobalVariable.sickType
            self.navigationController?.pushViewController(objc)
        }
        cell.configureShadow()
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 90
    }
    
}
extension sickViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.attachments.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imgsCollection.dequeueReusableCell(withClass: docCell.self, for: indexPath)
        heightConstant.constant = 121
        cell.imgVW.image = self.viewModel.attachments[indexPath.row]
        cell.delButtonClicked = {
            if self.viewModel.attachments.count != 0
            {
                self.viewModel.attachments.remove(at: indexPath.row)
                self.imgsCollection.reloadData()
            }
            else
            {
                self.heightConstant.constant = 0

            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imgsCollection.frame.width/3, height: 120.0)
    }
   
}
extension sickViewController {
    
    func getLeavesData() {
        self.showProgressBar()
        viewModel.gettLeavesAPI { (status,message) in
            if status == true
            {
                self.hideProgressBar()
                self.archiveTable.reloadData()
                self.archiveTable.delegate = self
                self.archiveTable.dataSource = self
            }
            else
            {
                self.hideProgressBar()
            }
        }
    }
    func applySickLeaveAPI() {
        self.showProgressBar()
        viewModel.applyLeaveApi{ (status,message) in
            self.hideProgressBar()
            if status == true {
                self.hideProgressBar()
                self.showToast(message)
                self.scrolll.scrollToTop(animated: true)

                self.resetData()
            } else {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
    }
}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
