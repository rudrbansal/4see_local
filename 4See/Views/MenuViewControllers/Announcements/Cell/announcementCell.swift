//
//  announcementCell.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit

class announcementCell: UITableViewCell
{

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!

    var ButtonClicked: (()->())?
    
    var cellModel : infoList? {
        didSet {
            if let model = cellModel
            {
                    nameLbl.text = model.title
                    let arr  = model.createdAt?.components(separatedBy: "T")
                    print(arr)
                    dateLbl.text = createDateStamp(dateFromBackEnd: arr![0])
                
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
    func createDateStamp(dateFromBackEnd:String)->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateFromBackEnd)
        formatter.dateFormat = "yyyy-MM-dd"
        let requiredDate = formatter.string(from: date ?? Date())
        return requiredDate
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func viewbtn(_ sender: Any)
    {
        self.ButtonClicked?()

    }
    
}
