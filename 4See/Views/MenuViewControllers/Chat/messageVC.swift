//
//  messageVC.swift
//  4See
//
//  Created by Gagan Arora on 04/03/21.
//

import UIKit
import SideMenu
import DropDown

enum viewType
{
    case sendMsg
    case inbox
    case reply
    
}
enum msgType
{
    case All
    case Unread
    case RecycleBin
    case Sent
}
class messageVC: BaseViewController,UITextViewDelegate
{
    override class var storyboardIdentifier: String
    {
        return "messageVC"
    }
    
    @IBOutlet weak var subjectVW: UIView!
    @IBOutlet weak var sendMsgBtn: UIButton!
    @IBOutlet weak var inboxAbtn: UIButton!
    @IBOutlet weak var subjectLBL: UITextField!
    @IBOutlet weak var msgTxtVW: UITextView!
    @IBOutlet weak var msgVW: UIView!
    @IBOutlet weak var btnVW: UIView!
    @IBOutlet weak var msgsTable: UITableView!
    @IBOutlet weak var sendToTFT: UITextField!
    @IBOutlet weak var sendToVW: UIView!
    
    //MARK:- View Changes
    @IBOutlet weak var sendMsgVW: UIView!
    @IBOutlet weak var inboxView: UIView!
    
    //MARK:- Reply View Changes
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyTxtView: UITextView!
    @IBOutlet weak var msgTxtView: UITextView!
    
    var type : viewType = .sendMsg
    var viewModel = messageViewModel()
    let dropDown = DropDown()
    var recieverId = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getBossMessagesListAPI()
        
        msgTxtVW.delegate = self
        replyTxtView.delegate = self
        
        initSideMenuView()
        colorTransition()
        configureTableView()
        sendToTFT.setPlaceholder("Send To:", withColor: BaseColors.themeColor)
        subjectLBL.setPlaceholder("Subject:", withColor: BaseColors.themeColor)
        msgTxtVW.text = "Message:"
        replyTxtView.text = "Reply Message:"
        replyTxtView.textColor = UIColor.black
        
        msgTxtVW.textColor = BaseColors.themeColor
        reset()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resett()
        getBossMessagesListAPI()
    }
    
    private func configureTableView() {
        msgsTable.register(nibWithCellClass: inboxCell.self)
    }
    
    func reset()
    {
        sendMsgBtn.backgroundColor = BaseColors.themeColor
        sendMsgBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
        inboxAbtn.layer.borderWidth = 1
        inboxAbtn.borderColor = BaseColors.themeColor
        inboxAbtn.clipsToBounds = true
        inboxAbtn.backgroundColor = BaseColors.whiteColor
        inboxAbtn.setTitleColor(BaseColors.themeColor, for: .normal)
        
        msgVW.isHidden = false
        inboxView.isHidden = true
    }
    
    func resett()
    {
        if  GlobalVariable.msgType == "Send"
        {
            sendMsgBtn.backgroundColor = BaseColors.themeColor
            sendMsgBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            inboxAbtn.layer.borderWidth = 1
            inboxAbtn.borderColor = BaseColors.themeColor
            inboxAbtn.clipsToBounds = true
            inboxAbtn.backgroundColor = BaseColors.whiteColor
            inboxAbtn.setTitleColor(BaseColors.themeColor, for: .normal)
            replyView.isHidden = true
            
            msgVW.isHidden = false
            inboxView.isHidden = true
        }
        else if GlobalVariable.msgType == "Inbox"
        {
            inboxAbtn.backgroundColor = BaseColors.themeColor
            inboxAbtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            sendMsgBtn.layer.borderWidth = 1
            sendMsgBtn.borderColor = BaseColors.themeColor
            sendMsgBtn.clipsToBounds = true
            sendMsgBtn.backgroundColor = BaseColors.whiteColor
            sendMsgBtn.setTitleColor(BaseColors.themeColor, for: .normal)
            replyView.isHidden = true
            
            msgVW.isHidden = true
            inboxView.isHidden = false
        }
        else if GlobalVariable.msgType == "Reply"
        {
            sendMsgBtn.backgroundColor = BaseColors.themeColor
            sendMsgBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            inboxAbtn.layer.borderWidth = 1
            inboxAbtn.borderColor = BaseColors.themeColor
            inboxAbtn.clipsToBounds = true
            inboxAbtn.backgroundColor = BaseColors.whiteColor
            inboxAbtn.setTitleColor(BaseColors.themeColor, for: .normal)
            
            msgVW.isHidden = true
            replyView.isHidden = false
            inboxView.isHidden = true
            let arr = GlobalVariable.selectedMsginfo!.createdAt!.components(separatedBy: "T")
            msgTxtView.text =  "Reply \n\(String(describing: GlobalVariable.selectedMsginfo!.subject!))\n\(String(describing: arr[0]))\n\n\(String(describing: GlobalVariable.selectedMsginfo!.body!))"
            
        }
        else
        {
            sendMsgBtn.backgroundColor = BaseColors.themeColor
            sendMsgBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            inboxAbtn.layer.borderWidth = 1
            inboxAbtn.borderColor = BaseColors.themeColor
            inboxAbtn.clipsToBounds = true
            inboxAbtn.backgroundColor = BaseColors.whiteColor
            inboxAbtn.setTitleColor(BaseColors.themeColor, for: .normal)
            replyView.isHidden = true
            
            msgVW.isHidden = false
            inboxView.isHidden = true
        }
    }
    //MARK:- SideMenu Function
    
    func initSideMenuView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        SideMenuManager.default.leftMenuNavigationController = storyboard.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
    }
    func colorTransition()
    {
        if type == .sendMsg
        {
            sendMsgBtn.backgroundColor = BaseColors.themeColor
            sendMsgBtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            inboxAbtn.layer.borderWidth = 1
            inboxAbtn.borderColor = BaseColors.themeColor
            inboxAbtn.clipsToBounds = true
            inboxAbtn.backgroundColor = BaseColors.whiteColor
            inboxAbtn.setTitleColor(BaseColors.themeColor, for: .normal)
            GlobalVariable.msgType = "Send"
            msgVW.isHidden = false
            inboxView.isHidden = true
            replyView.isHidden = true
        }
        else
        {
            inboxAbtn.backgroundColor = BaseColors.themeColor
            inboxAbtn.setTitleColor(BaseColors.whiteColor, for: .normal)
            sendMsgBtn.layer.borderWidth = 1
            sendMsgBtn.borderColor = BaseColors.themeColor
            sendMsgBtn.clipsToBounds = true
            sendMsgBtn.backgroundColor = BaseColors.whiteColor
            sendMsgBtn.setTitleColor(BaseColors.themeColor, for: .normal)
            GlobalVariable.msgType = "Inbox"
            replyView.isHidden = true
            
            msgVW.isHidden = true
            inboxView.isHidden = false
        }
    }
    
    func resetView()
    {
        subjectLBL.text = ""
        sendToTFT.text = ""
        msgTxtVW.text = "Message:"
    }
   
    @IBAction func sendToBtn(_ sender: Any)
    {
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            self.sendToTFT.text = item
            self.recieverId = self.viewModel.messagesBossList!.data![index]._id!
            self.dropDown.hide()
        }
    }
    
    @IBAction func back(_ sender: Any)
    {
        self.navigationController?.popViewController()
    }
  
    @IBAction func menuAction(_ sender: Any)
    {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func inboxBtn(_ sender: Any)
    {
        type = .inbox
        colorTransition()
    }
   
    @IBAction func sendBtn(_ sender: Any)
    {
        type = .sendMsg
        colorTransition()
    }
   
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if GlobalVariable.msgType == "Reply" {
            if replyTxtView.text == "" {
                self.showToast("Please enter reply text.")
            } else {
                replyMessageAPI()
            }
        } else {
            if sendToTFT.text == "" {
                self.showToast("Send To field is required.")
            } else if subjectLBL.text == "" {
                self.showToast("Subject field is required.")
            } else if msgTxtVW.text == "Message:" {
                self.showToast("Message field is required.")
            } else {
                sendMessageAPI(recieverId: self.recieverId)
            }
        }
        
    }
    
    @IBAction func segmentsAction(_ sender: Any) {
        switch (sender as AnyObject).tag{
        case 1:
            print("All Button Clicked")
            self.msgsTable.isHidden = false
            
            self.viewModel.msgtype = .All
            self.viewModel.filterMsgsList = self.viewModel.messagesList!.messages!.filter { $0.recipients!.isDeleted == "0"}
            self.msgsTable.reloadData()
        case 2:
            print("Unread Button Clicked")
            self.viewModel.msgtype = .Unread
            self.msgsTable.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.viewModel.filterMsgsList = self.viewModel.messagesList!.messages!.filter { $0.recipients!.isRead == "0"}
                self.viewModel.filterMsgsList = self.viewModel.filterMsgsList.filter { $0.recipients!.isDeleted == "0"}

                self.msgsTable.reloadData()
                self.msgsTable.layoutIfNeeded()
            })
            
        case 3:
            print("Recycle Button Clicked")
            self.viewModel.msgtype = .RecycleBin
            self.viewModel.filterMsgsList = self.viewModel.messagesList!.messages!.filter { $0.recipients!.isDeleted == "1"}
            getSentMessagesAPI()
        case 4:
            print("Sent Button Clicked")
            self.viewModel.msgtype = .Sent
            getSentMessagesAPI()
        default:
            print("No Button Selected")
            self.viewModel.filterMsgsList =  self.viewModel.messagesList!.messages!
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTxtVW.textColor == BaseColors.themeColor {
            msgTxtVW.text = nil
        }
        else if replyTxtView.textColor == UIColor.black {
            replyTxtView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxtVW.text.isEmpty {
            msgTxtVW.text = "Message:"
            msgTxtVW.textColor = BaseColors.themeColor
        }
        else if replyTxtView.text.isEmpty {
            replyTxtView.text = "Reply Message:"
        }
    }
    
}

extension messageVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterMsgsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withClass: inboxCell.self)
        cell.configureShadow()
        cell.cellModel = viewModel.filterMsgsList[indexPath.row]
        cell.deleteBtn.isHidden = false
        cell.unreadBtn.isHidden = false
        if viewModel.filterMsgsList[indexPath.row].recipients?.isFavorite == "1" {
            cell.unreadBtn.isHidden = true
            cell.favBtn.isHidden = false
        } else if viewModel.filterMsgsList[indexPath.row].recipients?.isRead == "1" {
            cell.unreadBtn.isHidden = true
            cell.favBtn.isHidden = true
        } else {
            cell.unreadBtn.isHidden = false
            cell.favBtn.isHidden = true
        }
        if self.viewModel.msgtype == .Sent {
            cell.unreadBtn.isHidden = true
        }
        
        if self.viewModel.msgtype == .RecycleBin {
            if viewModel.filterMsgsList[indexPath.row].recipients == nil {
                cell.unreadBtn.isHidden = true
            }
            cell.unreadBtn.isHidden = true
            cell.favBtn.isHidden = true
            cell.deleteBtn.isHidden = true
        }
        cell.viewButtonClicked  = { [self] in
            let objc = msgDetailsVC()
            GlobalVariable.messageId = self.viewModel.filterMsgsList[indexPath.row]._id!
            objc.viewModel.selectedMsgInfo = self.viewModel.filterMsgsList[indexPath.row]
            self.navigationController?.pushViewController(objc)
        }
        
        cell.deleteButtonClicked = {
            if self.viewModel.filterMsgsList[indexPath.row].recipients == nil {
                self.viewModel.deleteMsgValues(self.viewModel.filterMsgsList[indexPath.row]._id ?? "")
            } else {
                self.viewModel.deleteMsgValues((self.viewModel.filterMsgsList[indexPath.row].recipients?._id!)!)
            }
            
            self.getMessagesDeleteAPI()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

extension messageVC {
    
    func getMessagesListAPI(completion: @escaping () -> ()) {
        self.showProgressBar()
        viewModel.getMessagesListAPI { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                if (self.viewModel.messagesList?.messages?.count ?? 0) > 0 {
                    let filterMsgsList = self.viewModel.messagesList!.messages!.filter { $0.recipients!.isRead == "0"}
                    let finalfilterMsgsList = filterMsgsList.filter { $0.recipients!.isDeleted == "0"}
                    self.inboxAbtn.setTitle("Inbox (\(finalfilterMsgsList.count))", for: .normal)
                }
            } else {
                self.hideProgressBar()
                self.showToast(message)
            }
            completion()
        }
    }
    
    func sendMessageAPI(recieverId:String) {
        self.showProgressBar()
        self.viewModel.addMsgValues(self.subjectLBL.text!, self.msgTxtVW.text,recieverId)
        
        viewModel.addMsgAPI { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                self.showToast(message)
                self.resetView()
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)
                
            }
        }
    }
    
    func getBossMessagesListAPI() {
        self.showProgressBar()
        viewModel.getBossMessagesListAPI { (status,message)  in
            self.hideProgressBar()
            if status == true {
                self.getMessagesListAPI {
                    self.msgsTable.reloadData()
                    self.msgsTable.delegate = self
                    self.msgsTable.dataSource = self
                }
                self.dropDown.anchorView = self.sendToVW
                self.dropDown.separatorColor = .lightGray
                self.dropDown.width = 200
                self.dropDown.direction = .bottom
                self.dropDown.tintColor  = BaseColors.themeColor
                
                for ind in 0..<self.viewModel.messagesBossList!.data!.count {
                    if self.viewModel.messagesBossList!.data![ind]._id! != AppConfig.loggedInUser?.userInfo?.id! {
                        self.dropDown.dataSource.append(self.viewModel.messagesBossList!.data![ind].name!)
                        self.dropDown.cellConfiguration = { (index, item) in return "\(item)" }
                    }
                }
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)
            }
        }
    }
    
    func replyMessageAPI() {
        self.showProgressBar()
        self.viewModel.replyMsgValues("Reply", self.replyTxtView.text,GlobalVariable.selectedMsginfo!._id!,GlobalVariable.selectedMsginfo!.senders!._id!)
        
        viewModel.replyMsgAPI { (status,message)  in
            self.hideProgressBar()
            if status == true {
                self.showToast(message)
                
                self.type = .sendMsg
                GlobalVariable.msgType = "Send"
                self.colorTransition()
                self.resetView()
            } else {
                self.hideProgressBar()
                self.showToast(message)
                
            }
        }
    }
    
    func getMessagesDeleteAPI() {
        self.showProgressBar()
        
        viewModel.deleteMsgApi { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                self.hideProgressBar()
                if self.viewModel.msgtype == .Sent {
                    self.getMessagesListAPI {
                        self.getSentMessagesAPI()
                    }
                } else {
                    self.getMessagesListAPI {
                        self.msgsTable.reloadData()
                        self.msgsTable.delegate = self
                        self.msgsTable.dataSource = self
                    }
                }
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)
                
            }
        }
    }
    
    func getSentMessagesAPI() {
        self.showProgressBar()
        
        viewModel.getSentMessagesListAPI { (status,message)  in
            self.hideProgressBar()
            if status == true
            {
                self.msgsTable.reloadData()
            }
            else
            {
                self.hideProgressBar()
                self.showToast(message)
                
            }
        }
    }
    
}
