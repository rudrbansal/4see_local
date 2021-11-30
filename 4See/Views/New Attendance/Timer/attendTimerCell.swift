//
//  attendTimerCell.swift
//  4See
//
//  Created by Gagan Arora on 08/04/21.
//

import UIKit
import Gradients

class attendTimerCell: UITableViewCell
{

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var clockedInTimeLbl: UILabel!
    @IBOutlet weak var BreakTimeLbl: UILabel!
    @IBOutlet weak var clockedOut: UILabel!
    let secondModel = attendanceViewModel()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    func gradientViewSetup(view: UIView) {
        
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        
        let gradientLayer = Gradients.linear(to: Direction.right, colors: [BaseColors.themeColor.cgColor,UIColor.init(red: 41, green: 144, blue: 205)!.cgColor], locations: [0.0,1.0])
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 350, height: 141)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
