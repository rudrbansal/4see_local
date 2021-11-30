//
//  archiveCell.swift
//  4See
//
//  Created by Gagan Arora on 05/03/21.
//

import UIKit

class archiveCell: UITableViewCell
{

    @IBOutlet weak var shadowVw: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    var viewButtonClicked: (()->())?
    var statusButtonClicked: (()->())?

    var cellModel : leaveInfo? {
        didSet {
            if let model = cellModel
            {
                let arr  = model.date?.components(separatedBy: "T")
                if arr == nil{
                    dateLbl.text = ""
                }else{
                    dateLbl.text = createDateStamp(dateFromBackEnd: arr![0])
                }
                
                nameLbl.text = model.reason
                if model.status == "0"
                {
                    statusBtn.setTitle("Pending", for: .normal)
                    statusBtn.backgroundColor = BaseColors.themeColor
                }
                else if model.status == "1"
                {
                    statusBtn.setTitle("Approved", for: .normal)
                    statusBtn.backgroundColor = UIColor.systemGreen
                }
                else if model.status == "2"
                {
                    statusBtn.setTitle("Declined", for: .normal)
                    statusBtn.backgroundColor = BaseColors.redColor
                }
            }
        }
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    func configureShadow() {
        setNeedsLayout()
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.shadowVw.dropShadow()
        }
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
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func statusBtnAction(_ sender: Any)
    {
        self.statusButtonClicked?()

    }
    
    @IBAction func viewBtnAction(_ sender: Any)
    {
        self.viewButtonClicked?()

    }
}
