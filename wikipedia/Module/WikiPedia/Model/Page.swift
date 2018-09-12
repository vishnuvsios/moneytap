//
//	Page.swift
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//	Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//	Model file Generated using: 
//	Vin.Favara's JSONExportV https://github.com/vivi7/JSONExport 
//	(forked from Ahmed-Ali's JSONExport)
//

import Foundation
import SwiftyJSON

class Page{

	var index : Int!
	var ns : Int!
	var pageid : Int!
	var terms : Term!
	var thumbnail : Thumbnail!
	var title : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		index = json["index"].intValue
		ns = json["ns"].intValue
		pageid = json["pageid"].intValue
		let termsJson = json["terms"]
		if termsJson != JSON.null{
			terms = Term(fromJson: termsJson)
		}
		let thumbnailJson = json["thumbnail"]
		if thumbnailJson != JSON.null{
			thumbnail = Thumbnail(fromJson: thumbnailJson)
		}
		title = json["title"].stringValue
	}

}
