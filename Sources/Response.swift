//
//  Response.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation



public class Response {
	
	public let httpStatus:Int
	
	public var errorCode:Int?
	
	public var message:String?
	
	public var jsonResponse:[String:Any]
	
	init?(urlResponse:URLResponse?, body:Data?) {
		guard let httpResponse = urlResponse as? HTTPURLResponse
			,let body:Data = body
			,let jsonBody = try? JSONSerialization.jsonObject(with: body, options: [])
			,let jsonResponse = jsonBody as? [String:Any]
			else {
				return nil
		}
		self.jsonResponse = jsonResponse
		httpStatus = httpResponse.statusCode
		if httpStatus == 422
			 {
			errorCode = jsonResponse["ErrorCode"] as? Int
			message = jsonResponse["Message"] as? String
		}
	}
	
}
