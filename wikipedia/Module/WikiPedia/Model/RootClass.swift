//
//	RootClass.swift
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//	Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//	Model file Generated using: 
//	Vin.Favara's JSONExportV https://github.com/vivi7/JSONExport 
//	(forked from Ahmed-Ali's JSONExport)
//

import Foundation
import SwiftyJSON

class RootClass{

	var batchcomplete : Bool!
	var continueField : Continue!
	var query : Query!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		batchcomplete = json["batchcomplete"].boolValue
		let continueFieldJson = json["continue"]
		if continueFieldJson != JSON.null{
			continueField = Continue(fromJson: continueFieldJson)
		}
		let queryJson = json["query"]
		if queryJson != JSON.null{
			query = Query(fromJson: queryJson)
		}
	}

}
