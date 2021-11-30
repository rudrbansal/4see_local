//
//  policyCell.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit

class policyCell: UITableViewCell
{
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    var ButtonClicked: (()->())?

    var cellModel : policyInfo? {
        didSet {
            if let model = cellModel
            {
                if model.document!.contains(".png")
                {
                    viewBtn.setTitle("View", for: .normal)
                }
                else
                {
                    viewBtn.setTitle("View PDF", for: .normal)

                }
                nameLbl.text = model.title
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
    @IBAction func viewBtn(_ sender: Any)
    {
        self.ButtonClicked?()

    }
    
}
