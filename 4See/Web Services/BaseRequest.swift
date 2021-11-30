//
//  BaseRequest.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import UIKit
import Alamofire

protocol ServiceRequestDelegate {
    func successWithdata(response: BaseResponse);
    func failureWithdata(response: BaseResponse);
}

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    
    let reachabilityManager = NetworkReachabilityManager()
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the cellular")
            }
        })
    }
    
}

class BaseRequest: NSObject {
    
    var delegate: ServiceRequestDelegate!
    
    func sendRequestWithJson(dataObject: AnyObject?, header: String?, url: String, type: RequestType, request: APIRequests){
        
        var headerPrms = HTTPHeaders()
        if let token = header {
            headerPrms = ["Authorization" : "\(token)"]
        }
        
        print("Url: \(url)")
        print("Parameters: \(dataObject as Any)")
        print("Headers: \(headerPrms)")
        
        let requestType = getRequestType(requestType: type)
        
        var encoding:ParameterEncoding = URLEncoding.default
        if type == .RType_Post || type == .RType_Put || type == .RType_Delete {
            encoding = JSONEncoding.init(options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        
        Alamofire.AF.request(url, method: requestType, parameters: dataObject as? Parameters, encoding: encoding , headers: headerPrms).responseJSON { (dataResponse) in
            print(dataResponse)
            self.serviceResult(responseObject: dataResponse, serviceType: request)
        }
        
    }
    
    func sendRequestWithImage(imageDataArray: [Data?]?, fileName: String, parameters: [String : Any], header: String, url: String, type: RequestType, request: APIRequests) {
        
        let headers : HTTPHeaders = [
            "Authorization": "\(header)",
        ]
        
        print("Url: \(url)")
        print("Parameters: \(parameters as Any)")
        print("Headers: \(headers)")
        
        let requestType = getRequestType(requestType: type)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let imageDataLocArray = imageDataArray {
                for imageData in imageDataLocArray {
                     if let imageData = imageData {
                        multipartFormData.append(imageData, withName: "\(fileName)", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    }
                }
            }
        }, to: url,method: requestType,headers: headers).responseJSON(completionHandler: { (dataResponse) in
            print("dataResponse: \(dataResponse)")
            self.serviceResult(responseObject: dataResponse, serviceType: request)
        })
        
    }
    
    //MARK: - Utility
    func getRequestType(requestType: RequestType)->HTTPMethod{
        switch requestType{
        case .RType_Get:
            return HTTPMethod.get
        case .RType_Post:
            return HTTPMethod.post
        case .RType_Put:
            return HTTPMethod.put
        case . RType_Delete:
            return HTTPMethod.delete
        }
    }
    
    //MARK: - Result
    func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        
    }
  
   

}
