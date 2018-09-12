//
//	Query.swift
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//	Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//	Model file Generated using: 
//	Vin.Favara's JSONExportV https://github.com/vivi7/JSONExport 
//	(forked from Ahmed-Ali's JSONExport)
//

import Foundation
import SwiftyJSON

class Query{

	var pages : [Page]!
	var redirects : [Redirect]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		pages = [Page]()
		let pagesArray = json["pages"].arrayValue
		for pagesJson in pagesArray{
			let value = Page(fromJson: pagesJson)
			pages.append(value)
		}
		redirects = [Redirect]()
		let redirectsArray = json["redirects"].arrayValue
		for redirectsJson in redirectsArray{
			let value = Redirect(fromJson: redirectsJson)
			redirects.append(value)
		}
	}

}
