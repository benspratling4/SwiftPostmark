//
//  Server.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation
open class Server {
	
	///post mark's "server token" as oppossed to an "account token"
	private var token:String
	
	public init(token:String) {
		self.token = token
	}
	
	public static func testServer()->Server {
		return Server(token: "POSTMARK_API_TEST")
	}
	
	public static let rootURL:URL = URL(string: "https://api.postmarkapp.com")!
	
	public static let emailURL:URL = Server.rootURL.appendingPathComponent("email")
	
	public static let batchEmailURL:URL = Server.emailURL.appendingPathComponent("batch")
	
	///send one email
	public func requestForSendingMessage(_ message:Message)->URLRequest {
		var request:URLRequest = URLRequest(url: Server.emailURL)
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue(token, forHTTPHeaderField: "X-Postmark-Server-Token")
		
		request.httpBody = try? JSONSerialization.data(withJSONObject: message.json, options: [])
		request.httpMethod = "POST"
		return request
	}
	
	///send multiple emails with one api call
	public func requestForSendingMessages(_ messages:[Message])->URLRequest {
		var request:URLRequest = URLRequest(url: Server.batchEmailURL)
		
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue(token, forHTTPHeaderField: "X-Postmark-Server-Token")
		let allMessages:[[String:Any]] = messages.map{$0.json}
		request.httpBody = try? JSONSerialization.data(withJSONObject: allMessages, options: [])
		
		return request
	}

}
