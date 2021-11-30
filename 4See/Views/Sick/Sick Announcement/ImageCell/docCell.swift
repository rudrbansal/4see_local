//
//  docCell.swift
//  4See
//
//  Created by Gagan Arora on 01/04/21.
//

import UIKit

class docCell: UICollectionViewCell {

    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet weak var deleteAction: UIButton!
    var delButtonClicked: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deletee(_ sender: Any)
    {
        self.delButtonClicked?()
    }
}
