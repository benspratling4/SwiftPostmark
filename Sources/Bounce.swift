//
//  Bounce.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation


public struct Bounce {
	
	///bounce ID, not message ID
	public var id:Int
	public var type:String
	public var email:String
	public var inactive:Bool
	public var canActivate:Bool
	
	public var from:String?
	public var typeCode:Int?
	public var name:String?
	public var tag:String?
	public var subject:String?
	public var messageID:String?
	public var serverID:Int?
	public var details:String?
	public var description:String?
	
	
	/// create an instance from the webhook body data
	public init?(body:Data) {
		guard let bodyJson:Any = try? JSONSerialization.jsonObject(with: body, options: [])
			,let json:[String:Any] = bodyJson as? [String:Any]
			,let id:Int = json["ID"] as? Int
			,let type:String = json["Type"] as? String
			,let email:String = json["Email"] as? String
			,let inactive:Bool = json["Inactive"] as? Bool
			,let canActivate:Bool = json["CanActivate"] as? Bool
			else { return nil }
		self.id = id
		self.type = type
		self.email = email
		self.inactive = inactive
		self.canActivate = canActivate
		
		
		typeCode = json["TypeCode"] as? Int
		from = json["From"] as? String
		messageID = json["MessageID"] as? String
		name = json["Name"] as? String
		tag = json["Tag"] as? String
		serverID = json["ServerID"] as? Int
		description = json["Description"] as? String
		details = json["Details"] as? String
		subject = json["Subject"] as? String
		
	}
	
}
