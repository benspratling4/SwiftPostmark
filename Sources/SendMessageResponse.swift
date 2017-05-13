//
//  SendMessageResponse.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation

public class SendMessageResponse : Response {
	
	public var messageID:String
	
	public override init?(urlResponse:URLResponse?, body:Data?) {
		guard let body:Data = body
			,let jsonBody:Any = try? JSONSerialization.jsonObject(with: body, options: [])
			,let jsonResponse:[String:Any] = jsonBody as? [String:Any]
			,let id:String = jsonResponse["MessageID"] as? String
			else {
				return nil
		}
		messageID = id
		super.init(urlResponse: urlResponse, body: body)
	}
	
	///may return a SendMessageResponse, may return a Response
	public static func messageResponse(urlResponse:URLResponse?, body:Data?)->Response? {
		guard let messageResponse = SendMessageResponse(urlResponse: urlResponse, body: body) else {
			return Response(urlResponse: urlResponse, body: body)
		}
		return messageResponse
	}
	
}
