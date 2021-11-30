//
//  attendanceCell.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit

class attendanceCell: UITableViewCell
{
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusBtn: UILabel!
    
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var viewlbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    var ButtonViewClicked: (()->())?

    var cellModel : RegisterModel? {
        didSet {
            if let model = cellModel
            {
                if model._id?.date != ""
                {
                    if model.type == "0"
                    {
                        statusBtn.text = "Present"
                        statusBtn.backgroundColor = UIColor.systemGreen
                        dateLbl.text = model._id?.date
                        viewBtn.isHidden = false
                        lineLbl.isHidden = false

                        viewlbl.isHidden = false
                    } else if model.type == "1" {
                        statusBtn.text = "Work From Home"
                        statusBtn.backgroundColor = UIColor.init(hexString: "#57B0E4")
                        dateLbl.text = model._id?.date
                        viewBtn.isHidden = false
                        lineLbl.isHidden = false

                        viewlbl.isHidden = false
                    } else if model.type == "2" {
                        statusBtn.text = "Holiday"
                        statusBtn.backgroundColor = UIColor.init(hexString: "#FFCC02")
                        dateLbl.text = model._id?.date
                        viewBtn.isHidden = true
                        viewlbl.isHidden = true
                        lineLbl.isHidden = true
                    } else {
                        statusBtn.text = "Absent"
                        let ar = model.date!.components(separatedBy: "T")
                        dateLbl.text = ar[0]
                        viewBtn.isHidden = true
                        viewlbl.isHidden = true
                        lineLbl.isHidden = true
                        statusBtn.backgroundColor = UIColor.systemRed
                    }
                } else {
                    statusBtn.text = "Absent"
                    let ar = model.date!.components(separatedBy: "T")
                    dateLbl.text = ar[0]
                    viewBtn.isHidden = true
                    viewlbl.isHidden = true
                    lineLbl.isHidden = true
                    statusBtn.backgroundColor = UIColor.systemRed
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    func createDateStamp(dateFromBackEnd:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateFromBackEnd)
        formatter.dateFormat = "yyyy-MM-dd"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    
    @IBAction func viewAction(_ sender: Any) {
        ButtonViewClicked?()
    }
    
    
}
