//
//  announceDetailsVC.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu

class announceDetailsVC: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "announceDetailsVC"
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var descLBL: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    let viewModel = announcementViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSideMenuView()
        dataSetup()
    }
    func dataSetup()
    {
        descLBL.text = viewModel.details?.description
        let arr  = viewModel.details!.createdAt?.components(separatedBy: "T")
        print(arr)
        dateLbl.text = createDateStamp(dateFromBackEnd: arr![0])
        
        nameLbl.text = viewModel.details!.title!
        titleLbl.text = viewModel.details!.title!
        let urlString = UrlConfig.IMAGE_URL+viewModel.details!.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        imgVw.setImageOnView(urlString)
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController

    }
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
}
extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
