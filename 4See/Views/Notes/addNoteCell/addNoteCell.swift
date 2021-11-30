//
//  addNoteCell.swift
//  4See
//
//  Created by Gagan Arora on 07/04/21.
//

import UIKit

class addNoteCell: UITableViewCell
{
    @IBOutlet weak var addBtn: UIButton!
    var buttonAddClicked: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
