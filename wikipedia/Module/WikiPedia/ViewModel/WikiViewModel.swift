//
//  WikiViewModel.swift
//  moneyTap
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//

import Foundation
import SDWebImage
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

protocol WikipediaCompleteDelegate: class
{
    func completeAPICall(responce:String)
}

class WikiViewModel {
    
    weak var delegate: WikipediaCompleteDelegate?
    
    var Service = BaseService()
    var wikipediaArray:RootClass!

    func getWikipediaDetailsAPI()
    {
        
        let header = ["Content-Type": "application/json"]
        let postParameter: [String: Any] = ["":""]
        print(postParameter)
        do {
            try self.Service.serviceRequest(path: GETWIKIPEDIADETAILSLIST, method: HTTPMethod.get, parameters: postParameter, header: header,  onCompletion: { status, value in
                guard status else
                {
                    //fail
                    self.delegate?.completeAPICall(responce: "Fail")
                    return
                }
                //success
                let root = RootClass.init(fromJson: value)
                self.wikipediaArray = root
                self.delegate?.completeAPICall(responce: "Success")
                
            })
        } catch
        {
        }
    }

    
    func getRowCount() -> Int{
        
        if self.wikipediaArray != nil
        {
            return self.wikipediaArray.query.pages.count
        }
        return 0
    }
    
    func getTitleName(index:Int) -> String{
        guard let title = self.wikipediaArray.query.pages[index].title else {return ""}
        return title
    }
    
    func getDescriptionName(index:Int) -> String{
        
        return self.wikipediaArray.query.pages[index].terms.descriptionField[0]
    }
    
    func getImageUrl(index:Int) -> String{
        let imageValue : String!
        
        if (self.wikipediaArray.query.pages[index].thumbnail) != nil {
            guard let image = self.wikipediaArray.query.pages[index].thumbnail.source else {return ""}
            imageValue = image
            return image
        } else{
            imageValue = ""
        }
        return imageValue
    }
}
