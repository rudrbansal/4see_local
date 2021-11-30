//
//  addcell.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit

class addcell: UITableViewCell
{
    
    @IBOutlet weak var addBtn: UIButton!
    var buttonAddClicked: (()->())?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    func configureShadow() {
        setNeedsLayout()
        layoutIfNeeded()
        DispatchQueue.main.async {
            self.contentView.dropShadow()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addAction(_ sender: Any)
    {
        self.buttonAddClicked?()

    }
    
}
