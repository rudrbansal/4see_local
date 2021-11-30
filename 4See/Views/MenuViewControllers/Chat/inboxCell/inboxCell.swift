//
//  inboxCell.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit

class inboxCell: UITableViewCell
{
    @IBOutlet weak var centerLbl: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var unreadBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    var favButtonClicked: (()->())?
    var unreadButtonClicked: (()->())?
    var viewButtonClicked: (()->())?
    var deleteButtonClicked: (()->())?
    @IBOutlet weak var deleteBtn: UIButton!
    
    var cellModel : msgInfo? {
        didSet {
            if let model = cellModel
            {
                if AppConfig.loggedInUser?.userInfo?.userRole == "employee"
                {
                    subjectLbl.text = "Subject:"
                    msgLbl.text = model.body!
                    let arr = model.createdAt?.components(separatedBy:"T")
                    dateLbl.text = arr?[0]

                }
                else
                {
                    if model.senders == nil {
                        subjectLbl.text = "From: \(AppConfig.loggedInUser?.userInfo?.name ?? "")"
                    } else {
                        subjectLbl.text = "From: \(model.senders!.name!)"
                    }
                    msgLbl.text = "Subject: \(model.body!)"
                    let arr = model.createdAt?.components(separatedBy:"T")
                    dateLbl.text = arr?[0]

                }
                
            }
        }
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        configureShadow()
        
    }
    func configureShadow() {
        setNeedsLayout()
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.shadowView.dropShadow()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func unreadBtn(_ sender: Any)
    {
        self.unreadButtonClicked?()

    }
    @IBAction func viewBtn(_ sender: Any)
    {
        self.viewButtonClicked?()

    }
    
    @IBAction func deleteBtn(_ sender: Any)
    {
        self.deleteButtonClicked?()

    }
    @IBAction func favBtnAction(_ sender: Any)
    {
        self.favButtonClicked?()

    }
}
