//
//  messageViewModel.swift
//  4See
//
//  Created by Gagan Arora on 19/04/21.
//

import Foundation

class messageViewModel {

    typealias messagesAPICallback = (Bool,String) -> Void
    var completion : messagesAPICallback?
    var messagesList: MessageModel?
    var messagesBossList: BossMessageModel?
    var filteredBossList: BossMessageModel?
    var filterMsgsList = [msgInfo]()
    
    var selectedMsgInfo : msgInfo?
    var selectedBossMsgInfo : bossMsgInfo?
    var msgId: String?
    var msgtype : msgType = .All
    
    func getMessagesListAPI(completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.msgsListAPI(delegate: self)
    }
    func getSentMessagesListAPI(completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.sentMsgsListAPI(delegate: self)
    }
    func getBossMessagesListAPI(completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.bossMessgesListAPI(delegate: self)
    }
    //MARK:- Add msg api.....//
    
    func addMsgValues(_ subject:String,_ body:String,_ recipientId: String) {
        messageViewHandler.default.subject = subject
        messageViewHandler.default.body = body
//        messageViewHandler.default.parentId = parentId
        messageViewHandler.default.recipientId = recipientId
    }
    func addMsgAPI(_ completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.addMessageAPI(paramaters: messageViewHandler.default.addMsgObject(),delegate: self)
    }
    
    //MARK:- Reply Msg APi........//
    func replyMsgValues(_ subject:String,_ body:String,_ parentId: String,_ recipientId: String) {
        messageViewHandler.default.subject = subject
        messageViewHandler.default.body = body
        messageViewHandler.default.parentId = parentId
        messageViewHandler.default.recipientId = recipientId
    }
    func replyMsgAPI(_ completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.addMessageAPI(paramaters: messageViewHandler.default.replyMsgObject(),delegate: self)
    }
    //MARK:- Favourite Msg APi........//
    func favouriteMsgValues(_ parentId: String) {
        messageViewHandler.default.parentId = parentId
    }
    func favMsgAPI(_ completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.addFavouriteMsgAPI(paramaters: messageViewHandler.default.favMsgObject(),delegate: self)
    }
    //MARK:- Details Msg APi........//
    func detailsMsgValues(_ parentId: String) {
        messageViewHandler.default.parentId = parentId
    }
    func detailsApi(_ completion: @escaping messagesAPICallback) {
        self.completion = completion
        MessageRequest.shared.msgDetailsAPI(paramaters: messageViewHandler.default.msgDetailsObject(),delegate: self)
    }
    //MARK:- Delete Msg APi........//
    func deleteMsgValues(_ id: String) {
        messageViewHandler.default.id = id
    }
    func deleteMsgApi(_ completion: @escaping messagesAPICallback) {
        self.completion = completion
        if msgtype == .Sent {
            MessageRequest.shared.msgDeleteAPI(paramaters: messageViewHandler.default.msgDeleteSentObject(),delegate: self)
        } else {
            MessageRequest.shared.msgDeleteAPI(paramaters: messageViewHandler.default.msgDeleteObject(),delegate: self)
        }
        
    }
}

extension messageViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
        
        if response.requestType == APIRequests.RType_GetMsgsList {
            if let responseData = response.serverData["payload"] as? [String:Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    messagesList = try JSONDecoder().decode(MessageModel.self, from: jsonData)
                    filterMsgsList = self.messagesList!.messages!.filter { $0.recipients!.isDeleted == "0"}
                    
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(messagesList)
                }
                catch {
                    failureWithdata(response: response)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(false, data!)
                }
            }
            else {
                failureWithdata(response: response)
            }
        }
        else if response.requestType == APIRequests.RType_GetBossMsgsList {
            if let responseData = response.serverData["payload"] as? [String:Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    messagesBossList = try JSONDecoder().decode(BossMessageModel.self, from: jsonData)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(messagesBossList)
                }
                catch {
                    failureWithdata(response: response)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(false, data!)
                }
            }
            else {
                failureWithdata(response: response)
            }
        }
        
        else if response.requestType == APIRequests.RType_AddMessage {
            print(response.serverData)
            do {
                let data = response.serverData["message"] as? String
                print(data!)
                completion?(true,data!)
            }
            catch {
                let data = response.serverData["message"] as? String
                print(data!)
                failureWithdata(response: response)
                completion?(false,data!)
                
            }
        }
        
        else if response.requestType == APIRequests.RType_FavouriteMsg {
            print(response.serverData)
            do {
                let data = response.serverData["message"] as? String
                print(data!)
                completion?(true,data!)
            }
            catch {
                let data = response.serverData["message"] as? String
                print(data!)
                failureWithdata(response: response)
                completion?(false,data!)
                
            }
        }
        else if response.requestType == APIRequests.RType_MsgDetails {
            print(response.serverData)
            do {
                let data = response.serverData["message"] as? String
                print(data!)
                completion?(true,data!)
            }
            catch {
                let data = response.serverData["message"] as? String
                print(data!)
                completion?(false,data!)
                
            }
        }
        else if response.requestType == APIRequests.RType_MsgDelete {
            print(response.serverData)
            do {
                let data = response.serverData["message"] as? String
                print(data!)
                completion?(true,data!)
            }
            catch {
                let data = response.serverData["message"] as? String
                print(data!)
                completion?(false,data!)
                
            }
        }
        else if response.requestType == APIRequests.RType_MsgSent {
            if let responseData = response.serverData["payload"] as? [String:Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                    let messagesList = try JSONDecoder().decode(MessageModel.self, from: jsonData)
                    if msgtype == .Sent {
                        filterMsgsList = messagesList.messages!.filter { $0.isDeleted == "0"}
                    } else {
                        filterMsgsList.append(contentsOf: messagesList.messages!.filter { $0.isDeleted == "1"})
                    }
                    
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(true, data!)
                    print(messagesList)
                }
                catch {
                    failureWithdata(response: response)
                    let data = response.serverData["message"] as? String
                    print(data!)
                    completion?(false, data!)
                }
            }
            else {
                failureWithdata(response: response)
            }
        }
        else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {

        failureWithdata(response: response)
    }
    
}
