//
//  editToolsViewController.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu
import SDWebImage

class editToolsViewController: BaseViewController
{

    override class var storyboardIdentifier: String
    {
        return "editToolsViewController"
    }
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var productNameTFT: UITextField!
    @IBOutlet weak var serialNumberTFT: UITextField!
    @IBOutlet weak var productEditBtn: UIButton!
    @IBOutlet weak var serialNumberbtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    let viewModel = toolsTradeViewModel()
//    var ind: Int!
    var indArr = [UIImage]()

    var selectArr = NSMutableArray()
    var select = 0

    var type = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagesCollection.register(nibWithCellClass: imgsCell.self)
        productNameTFT.setPlaceholder("Product Name", withColor: BaseColors.themeColor)
        serialNumberTFT.setPlaceholder("Serial Number", withColor: BaseColors.themeColor)
        initSideMenuView()
        
    }
    
  
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        dataSetup()

    }
    func dataSetup()
    {
        if type == "edit"
        {
            if self.viewModel.selectedSystemInfo!.images!.count == 0
            {
                self.hideProgressBar()
                self.collectionHeightConstant.constant = 0
                self.topConstant.constant = 100
            }
            else
            {
                self.showProgressBar()
                self.collectionHeightConstant.constant = 150
                self.topConstant.constant = 240
            }
            saveBtn.setTitle("Save Edits", for: .normal)
            productEditBtn.isHidden = false
            serialNumberbtn.isHidden = false
            productNameTFT.text = viewModel.selectedSystemInfo?.title
            serialNumberTFT.text = viewModel.selectedSystemInfo?.serialNumber
            DispatchQueue.main.async { [weak self] in
                self!.hideProgressBar()

                UIView.animate(withDuration: 0.0) {
                    self!.view.layoutIfNeeded()
                    self!.imagesCollection.reloadData()
                }
                for ind in 0..<self!.viewModel.selectedSystemInfo!.images!.count
                    {
                        let imageUrl = URL(string: UrlConfig.IMAGE_URL+self!.viewModel.selectedSystemInfo!.images![ind])!
                        let image = try! UIImage(url: imageUrl)
                        self!.viewModel.attachments.append(image!)

                }
              }
           
        }
        else
        {
            saveBtn.setTitle("Save", for: .normal)
            self.hideProgressBar()

            productEditBtn.isHidden = true
            serialNumberbtn.isHidden = true
            productNameTFT.isUserInteractionEnabled = true
            serialNumberTFT.isUserInteractionEnabled = true
            self.collectionHeightConstant.constant = 0
            self.topConstant.constant = 100
        }
    }
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)

    }
    @IBAction func addPictureActions(_ sender: Any)
    {
        self.openImagePopUp { (pickerImage) in
            if let image = pickerImage {
                self.viewModel.attachments.append(image)
                self.collectionHeightConstant.constant = 150
                self.topConstant.constant = 240
                
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                    self.imagesCollection.reloadData()
                }

            }
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        switch (sender as AnyObject).tag {
        case 1:
            productNameTFT.becomeFirstResponder()
            productNameTFT.isUserInteractionEnabled = true
        case 2:
            serialNumberTFT.becomeFirstResponder()
            serialNumberTFT.isUserInteractionEnabled = true
        default:
            print("no")
        }
    }
    @IBAction func deletePictures(_ sender: Any)
    {
        if select == 1
        {
            if self.viewModel.attachments.count == 0 {
                self.collectionHeightConstant.constant = 0
                self.topConstant.constant = 100
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
                
            }
            else
            {
                
                self.viewModel.attachments = self.viewModel.attachments.filter { !indArr.contains($0) }
//                for k in indArr{
//                    self.viewModel.attachments.remove(at: k)
//                }
            }
            self.indArr.removeAll()
            self.imagesCollection.reloadData()
        }
        else
        {
            showToast("Please select image.")
        }
        
    }
    @IBAction func saveEdit(_ sender: Any)
    {
        if type == "edit"
        {
            viewModel.setEditValues(viewModel.selectedSystemInfo!.id!, productNameTFT.text!, serialNumberTFT.text!)
            addSystemApi()
        }
        else
        {
            viewModel.setEditValues("", productNameTFT.text!, serialNumberTFT.text!)
            addSystemApi()
        }
    }
}
extension editToolsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.attachments.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollection.dequeueReusableCell(withClass: imgsCell.self, for: indexPath)
        if viewModel.attachments.count != 0
        {
            self.hideProgressBar()
            self.collectionHeightConstant.constant = 150
            self.topConstant.constant = 240
            cell.profile_img.image =  self.viewModel.attachments[indexPath.row]
            cell.check_img.isHidden = true
            if select == 1{
                
                
                for k in indArr{
                    if(k == cell.profile_img.image){
                        cell.check_img.isHidden = false
                    }
                }
            }
            
//            if(select == 1 && ind == indexPath.row)
//            {
//                cell.check_img.isHidden = false
//            }
//            else
//            {
//                cell.check_img.isHidden = true
//            }
        }
        else
        {
            self.hideProgressBar()

            self.collectionHeightConstant.constant = 0
            self.topConstant.constant = 100
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imagesCollection.frame.width/2.1, height: 150.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item  =  self.viewModel.attachments[indexPath.row]
        if !indArr.contains(item) {// if it does not contains the index then add it
            indArr.append(item)
        } else {
            indArr = indArr.filter { $0 != item }
        }
        if indArr.count == 0 {
            select = 0
        } else {
            select = 1
        }
        imagesCollection.reloadData()
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if indArr.contains(indexPath.item) {// if it contains the index then delete from array
//            indArr.remove(at: indexPath.item)
//        }
//        imagesCollection.reloadData()
//    }
}
extension editToolsViewController {
    func addSystemApi() {
        self.showProgressBar()
        viewModel.addSystemApi{ (status,message) in
            self.hideProgressBar()
            if status == true {
                self.hideProgressBar()
                self.showToast(message)
                self.navigationController?.popViewController()

            } else {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                completion(data, response, error)
                }.resume()
        }
    func downloadImage(url: URL , tag : Int) {
            getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { () -> Void in
     
                    if let temp : UIImageView = self.view.viewWithTag(tag) as? UIImageView{
                        temp.image = UIImage(data: data)
                    }
                    else{
                    }
                }
            }
        }
}
extension UIImage {

    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }

}
