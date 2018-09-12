//
//	Thumbnail.swift
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//	Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//	Model file Generated using: 
//	Vin.Favara's JSONExportV https://github.com/vivi7/JSONExport 
//	(forked from Ahmed-Ali's JSONExport)
//

import Foundation
import SwiftyJSON

class Thumbnail{

	var height : Int!
	var source : String!
	var width : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json == nil{
			return
		}
		height = json["height"].intValue
		source = json["source"].stringValue
		width = json["width"].intValue
	}

}
