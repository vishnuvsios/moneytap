 //  Service.swift
 //  Sr.tn
 //
 //  Created by Vishnuvarthan Deivendiran on 11/09/18.
 //  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.

import Foundation
import Alamofire
import SwiftyJSON

typealias ServiceResponse = (Bool, JSON) -> Void

class BaseService {
    
    
    func serviceGETRequest(path: String , onCompletion: @escaping ServiceResponse) throws {
        let url = try path.asURL()
        Alamofire.request(url).responseJSON { response in
            
            print(response.result.value ?? "success")
            switch response.result
            {
            case .success:
                if let value = response.result.value {
                    onCompletion(true, JSON(value))
                }
            case .failure:
                let statusCode = response.response?.statusCode
                let fail: NSDictionary?
                if statusCode == 404 {
                    fail =  ["reason": "Server Not found"]
                    
                } else {
                    fail =  ["reason": "Can't access server (or) invalid response Errorcode:\(String(describing: statusCode))" as Any]
                }
                onCompletion(false, JSON(fail!))
            }
            
        }
        
        
    }

    
    func serviceRequest(path: String, method: HTTPMethod, parameters: Parameters, header: [String : String]?=nil, onCompletion: @escaping ServiceResponse) throws {
        let url = try path.asURL()
        print(url)
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
//                print(response.result.value)
            switch response.result
            {
            case .success:
                if let value = response.result.value {
                    onCompletion(true, JSON(value))
                }
            case .failure:
                let statusCode = response.response?.statusCode
                let fail: NSDictionary?
                if statusCode == 404 {
                    fail =  ["reason": "Server Not found"]
                    
                } else {
                    fail =  ["reason": "Can't access server (or) invalid response Errorcode:\(String(describing: statusCode))" as Any]
                }
                onCompletion(false, JSON(fail!))
            }
        }
    }
    func multipartServiceRequestUploadImage(path: String, parameters: Parameters, typeofFile:String,FileName:String,addHeader:HTTPHeaders, onCompletion: @escaping ServiceResponse) throws {
        
        let url = try path.asURL()
        
        
        let url2 = try! URLRequest(url: url, method: .post, headers: addHeader)
        Alamofire.upload( multipartFormData: {
            multipartFormData in
            
            for (key, value) in parameters {
                if let image = value as? UIImage {
                    let imageData = UIImageJPEGRepresentation(image, 0.5)
                    multipartFormData.append(imageData!, withName: key, fileName: FileName, mimeType: typeofFile)
                }
                    else if let pdf = value as? URL
                {
                    let pdfData = try! Data(contentsOf: pdf.asURL())
                    let data : Data = pdfData
                    multipartFormData.append(data, withName: key, fileName: FileName, mimeType: typeofFile)

                }
                else {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, with: url2 ,
           encodingCompletion: {
            encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    if let value = response.result.value {
                        onCompletion(true, JSON(value))
                    } else {
                        let failReason =  ["reason": response.result.error?.localizedDescription as AnyObject] as [String : Any]
                        onCompletion(true, JSON(failReason))
                    }
                }
            case .failure(let encodingError):
                let failReason =  ["reason": encodingError as AnyObject] as [String : Any]
                onCompletion(true, JSON(failReason))
            }
        })
    }
 

    func multipartServiceRequest(path: String,method: HTTPMethod,parameters: Parameters,image: UIImage?,fileName: String,fileType: String, onCompletion: @escaping ServiceResponse) throws {
        
        var url = try APP_BASEURL.asURL()
        url = url.appendingPathComponent(path)
        
        Alamofire.upload( multipartFormData: {
            multipartFormData in
            if let image = image {
                multipartFormData.append(UIImagePNGRepresentation(image)!, withName: "file", fileName: fileName, mimeType: "image/\(fileType)")
            }
            
            for (key, value) in parameters {
//                multipartFormData.append((value as AnyObject).stringValue.data(using: String.Encoding.utf8)!, withName: key)
                multipartFormData.append(key.data(using: .utf8)!, withName: value as! String)
                //                multipartFormData.append((value as AnyObject).stringValue.data(using: String.Encoding.utf8)!, withName: key)

            }
        }, to: url ,
           method: .post,
           encodingCompletion: {
            encodingResult in
            switch encodingResult
            {
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    if let value = response.result.value {
                        onCompletion(true, JSON(value))
                    } else {
                        let failReason =  ["reason": response.result.error?.localizedDescription as AnyObject] as [String : Any]
                        onCompletion(true, JSON(failReason))
                    }
                }
            case .failure(let encodingError):
                let failReason =  ["reason": encodingError as AnyObject] as [String : Any]
                onCompletion(true, JSON(failReason))
            }
        })
    }
    
    func upload(_ url:String, parameters: [String:Data], head: [String : String]?=nil, callback:@escaping (Bool, JSON?,JSON?) -> Void){
        
        let URL2 = try! URLRequest(url: url, method: .post, headers: head)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(value, withName: key, fileName: "picture.png", mimeType: "image/png")
            }
            
        }, with: URL2, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON{
                    response in
                    if let data = response.result.value{
                        DispatchQueue.main.async {
                            if(response.response?.statusCode == 200){
                                callback(true, JSON(data), JSON((response.response?.statusCode)!))
                            } else{
                                callback(false, JSON(data), JSON((response.response?.statusCode)!))
                            }
                        }
                    }
                }
                
            case .failure( _):
                 DispatchQueue.main.async {
                }
            }
        })
    }
}
