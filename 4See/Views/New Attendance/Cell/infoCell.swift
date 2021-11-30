//
//  infoCell.swift
//  4See
//
//  Created by Gagan Arora on 08/04/21.
//

import UIKit

class infoCell: UITableViewCell
{

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    var ButtonClicked: (()->())?

    var cellModel : CheckInModel? {
        didSet {
            if let model = cellModel
            {
                
                let new = model.date!.components(separatedBy: "T")
                print(new)
                let arr = new[1].components(separatedBy: ".")
                print(arr)
                titleLbl.text = new[0]+" at "+arr[0]
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
            self.shadowView.dropShadow()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewAction(_ sender: Any)
    {
        self.ButtonClicked?()

    }
}
