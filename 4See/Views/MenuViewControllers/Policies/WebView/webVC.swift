//
//  webVC.swift
//  4See
//
//  Created by Gagan Arora on 02/04/21.
//

import UIKit
import PDFKit
import WebKit

class webVC: BaseViewController,UIScrollViewDelegate, WKNavigationDelegate {
    
    override class var storyboardIdentifier: String {
        return "webVC"
    }
    var viewModel = PolicyViewModel()
    var helper:WKWebviewDownloadHelper!
    var pdfView = PDFView()
    var pdfURL: URL!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.selectedLeaveInfo!.document!.contains(".png") {
            webView.isHidden = false
            self.showProgressBar()
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: "http://4see.uiplay.co.za:3000/\(self.viewModel.selectedLeaveInfo!.document!)") {
                    let requestObj = URLRequest(url: url)
                    DispatchQueue.main.async {
                        self.webView.scrollView.delegate = self
                        self.webView.navigationDelegate = self
                        self.webView.load(requestObj)
                    }
                } else {
                    DispatchQueue.main.async {
                        //Remove loading view
                        self.hideProgressBar()
                    }
                }
            }
        } else {
            webView.isHidden = true
            secondView.addSubview(pdfView)
            self.showProgressBar()
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: "http://4see.uiplay.co.za:3000/\(self.viewModel.selectedLeaveInfo!.document!)") {
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
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    override func viewDidLayoutSubviews() {
        pdfView.frame = secondView.frame
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgressBar()
    }
}
