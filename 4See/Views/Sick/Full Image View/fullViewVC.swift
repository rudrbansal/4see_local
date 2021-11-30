//
//  fullViewVC.swift
//  4See
//
//  Created by Gagan Arora on 02/04/21.
//

import UIKit

class fullViewVC: UIViewController
{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // It's required to set content size of popup.
        contentSizeInPopup = CGSize(width: 330, height: 560)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var imgVW: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @IBAction func backAction(_ sender: Any)
    {
        self.dismiss(animated: true) {
        }
        
    }
    
}
