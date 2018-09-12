//
//	Term.swift
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//	Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//	Model file Generated using: 
//	Vin.Favara's JSONExportV https://github.com/vivi7/JSONExport 
//	(forked from Ahmed-Ali's JSONExport)
//

import Foundation
import SwiftyJSON

class Term{

	var descriptionField : [String]!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		descriptionField = [String]()
		let descriptionFieldArray = json["description"].arrayValue
		for descriptionFieldJson in descriptionFieldArray{
			descriptionField.append(descriptionFieldJson.stringValue)
		}
	}

}
