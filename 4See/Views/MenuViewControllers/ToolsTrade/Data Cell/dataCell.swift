//
//  dataCell.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit

class dataCell: UITableViewCell
{
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    var ButtonViewClicked: (()->())?
    
    var cellModel : sytemsInfo? {
        didSet {
            if let model = cellModel
            {
                    nameLbl.text = model.title!
                
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
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewBtnAction(_ sender: Any)
    {
        ButtonViewClicked?()

    }
    
}
