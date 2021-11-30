//
//  noteCell.swift
//  4See
//
//  Created by Gagan Arora on 07/04/21.
//

import UIKit

class noteCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    var ButtonViewClicked: (()->())?
    
    var cellModel : noteInfo? {
        didSet {
            if let model = cellModel
            {
                    nameLbl.text = model.note!
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
    @IBAction func viewBtnAction(_ sender: Any)
    {
        ButtonViewClicked?()

    }
}
