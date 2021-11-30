//
//  sick_announceViewController.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit
import SideMenu
import STPopup

class sick_announceViewController: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "sick_announceViewController"
    }
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var isCovidLbl: UILabel!
    @IBOutlet weak var covidNotLbl: UILabel!
    @IBOutlet weak var docsCollection: UICollectionView!
    @IBOutlet weak var noDocsLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var reasonnnLbl: UILabel!
    @IBOutlet weak var descLBL: UILabel!
    @IBOutlet weak var collHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var resasonStack : UIStackView!
    let viewModel = SickViewModel()
    var type = ""
    let objVerify = fullViewVC()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        initSideMenuView()
        docsCollection.register(nibWithCellClass: sickImgCell.self)
        collHeightConstant.constant = 0

        dataSetUp()
    }
    func dataSetUp()
    {
        let arr  = viewModel.selectedLeaveInfo?.createdAt?.components(separatedBy: "T")
        dateLbl.text = createDateStamp(dateFromBackEnd: arr![0])
        
        reasonLbl.text = viewModel.selectedLeaveInfo?.reason
        descLBL.text = viewModel.selectedLeaveInfo?.message
        daysLbl.text = viewModel.selectedLeaveInfo?.duration
        if viewModel.selectedLeaveInfo?.isCovid == "0"
        {
            isCovidLbl.text = "No"
        }
        else
        {
            isCovidLbl.text = "Yes"
        }
        if viewModel.selectedLeaveInfo?.covidNotificaton == "0"
        {
            covidNotLbl.text = "No"
        }
        else
        {
            covidNotLbl.text = "Yes"
        }
        if  viewModel.selectedLeaveInfo?.document!.count != 0
        {
            if viewModel.selectedLeaveInfo?.document!.count == 1 && viewModel.selectedLeaveInfo?.document![0] == ""
            {
                noDocsLbl.isHidden = false
                collHeightConstant.constant = 0
            }
            else
            {
                noDocsLbl.isHidden = true
                collHeightConstant.constant = 68
            }
            
        }
        else
        {
            noDocsLbl.isHidden = false
            collHeightConstant.constant = 0

        }
        if viewModel.selectedLeaveInfo?.status == "0"
        {
            statusBtn.setTitle("Pending", for: .normal)
            statusBtn.backgroundColor = BaseColors.themeColor
            resasonStack.isHidden = true
        }
        else if viewModel.selectedLeaveInfo?.status == "1"
        {
            statusBtn.setTitle("Approved", for: .normal)
            statusBtn.backgroundColor = UIColor.systemGreen
        }
        
        else if viewModel.selectedLeaveInfo?.status == "2"
        {
            statusBtn.setTitle("Declined", for: .normal)
            statusBtn.backgroundColor = BaseColors.redColor
        }
        
        docsCollection.delegate = self
        docsCollection.dataSource = self
        
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
      
    }
    @IBAction func back(_ sender: Any)
    {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is sickViewController {
                GlobalVariable.sickType = type
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }

    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
}
extension sick_announceViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  viewModel.selectedLeaveInfo!.document!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = docsCollection.dequeueReusableCell(withClass: sickImgCell.self, for: indexPath)
        cell.imgVW.setImageOnView(UrlConfig.IMAGE_URL+viewModel.selectedLeaveInfo!.document![indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popupController = STPopupController(rootViewController: objVerify)
        popupController.navigationBarHidden = true
        popupController.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTap)))

        popupController.backgroundView?.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        popupController.containerView.backgroundColor = .clear
        popupController.present(in: self)
        objVerify.imgVW.setImageOnView(UrlConfig.IMAGE_URL+viewModel.selectedLeaveInfo!.document![indexPath.row])
      
    }
    @objc func backgroundViewDidTap()
    {
        objVerify.dismiss(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: docsCollection.frame.width/6, height: 60.0)
    }
   
}
