//
//  notesViewModel.swift
//  4See
//
//  Created by Gagan Arora on 13/04/21.
//

import Foundation
import UIKit

class notesViewModel {

    typealias notesAPICallback = (Bool,String) -> Void
    var completion : notesAPICallback?
    var notesList: NotesModel?
    var selectedNoteInfo : noteInfo?

    
    func getNotesAPI(completion: @escaping notesAPICallback) {
        self.completion = completion
        NotesRequest.shared.notesListAPI(delegate: self)
    }
    //MARK:- Add note api.....//
    
    func addNoteValues(_ note:String,_ name:String) {
        notesViewHandler.default.note = note
        notesViewHandler.default.name = name

    }
    func addNoteAPI(_ completion: @escaping notesAPICallback) {
        self.completion = completion
        NotesRequest.shared.addNoteAPI(paramaters: notesViewHandler.default.addNoteObject(),delegate: self)
    }
    
    //MARK:- Edit note api.....//
    
    func editNoteValues(_ note:String, _ id: String,_ name:String) {
        notesViewHandler.default.note = note
        notesViewHandler.default.id = id
        notesViewHandler.default.name = name

    }
    func editNoteAPI(_ completion: @escaping notesAPICallback) {
        self.completion = completion
        NotesRequest.shared.editNoteAPI(paramaters: notesViewHandler.default.editNoteObject(),delegate: self)
    }
}

extension notesViewModel:ServiceRequestDelegate {
    
    func successWithdata(response: BaseResponse) {
            
            if response.requestType == APIRequests.RType_GetNotesList {
                if let responseData = response.serverData["payload"] as? [String:Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        notesList = try JSONDecoder().decode(NotesModel.self, from: jsonData)
                        let data = response.serverData["message"] as? String
                        print(data!)
                        completion?(true, data!)
                        print(notesList)
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
        else if response.requestType == APIRequests.RType_AddNote {
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
        else if response.requestType == APIRequests.RType_EditNote {
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

         else {
            failureWithdata(response: response)
        }
    }
    
    func failureWithdata(response: BaseResponse) {
        failureWithdata(response: response)
    }
    
}
