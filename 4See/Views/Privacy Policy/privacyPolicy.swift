//
//  privacyPolicy.swift
//  4See
//
//  Created by Gagan Arora on 05/05/21.
//

import UIKit
import PDFKit

class privacyPolicy: BaseViewController
{
    override class var storyboardIdentifier: String
    {
        return "privacyPolicy"
    }
    var pdfView = PDFView()
    var pdfURL: URL!
    @IBOutlet weak var secondVW: UIView!
    var viewModel = PolicyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        secondVW.addSubview(pdfView)
        self.showProgressBar()
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: "http://4see.uiplay.co.za:3000/uploads/policy/7417525930ebecd5e03a71ebb0c8b7e9") {
                if let pdfDocument = PDFDocument(url: url) {
                    DispatchQueue.main.async {
                        self.pdfView.autoScales = true
                        self.pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.pdfView.document = pdfDocument
                        self.hideProgressBar()
                    }
                } else {
                    DispatchQueue.main.async {
                        //Remove loading view
                        self.hideProgressBar()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    //Remove loading view
                    self.hideProgressBar()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        pdfView.frame = secondVW.frame
    }
}
