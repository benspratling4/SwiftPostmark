//
//  Message.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation



public struct Message {
	
	public var from:Address
	
	public var replyTo:Address?
	
	public var to:[Address]
	
	public var cc:[Address]?
	
	public var bcc:[Address]?
	
	public var subject:String?
	
	public var tag:String?
	
	public enum Body {
		case text(String)
		case html(String)
		//first text, second html
		case textAndHtml(String, String)
		
		public init(text:String, html:String) {
			self = .textAndHtml(text, html)
		}
		
		var text:String? {
			switch self {
			case .text(let string):
				return string
			case .textAndHtml(let string, _):
				return string
			default:
				return nil
			}
		}
		
		var html:String? {
			switch self {
			case .html(let string):
				return string
			case .textAndHtml(_, let string):
				return string
			default:
				return nil
			}
		}
	}
	
	public var body:Body
	
	public struct Attachment {
		public var name:String
		public var content:Data
		public var mimeType:String
		
		public init(name:String, mimeType:String, content:Data) {
			self.name = name
			self.content = content
			self.mimeType = mimeType
		}
		///for sending to the server
		public var json:[String:Any] {
			return [
				"Name":name
				,"ContentType":mimeType
				,"Content":content.base64EncodedString()
			]
		}
	}
	
	public var attachments:[Attachment]?
	
	public enum MessageInitError : Error {
		//value will be to, cc, or bcc
		case tooManyAddresses(String)
	}
	
	///throws MessageInitError if to, cc or bcc contain more than 50 addresses
	public init(from:Address, replyTo:Address? = nil, to:[Address], cc:[Address]? = nil, bcc:[Address]? = nil, subject:String?, tag:String? = nil, body:Body, attachments:[Attachment]? = nil) throws {
		
		if to.count > 50 {
			throw MessageInitError.tooManyAddresses("to")
		}
		if cc?.count ?? 0 > 50 {
			throw MessageInitError.tooManyAddresses("cc")
		}
		if bcc?.count ?? 0 > 50 {
			throw MessageInitError.tooManyAddresses("bcc")
		}
		
		self.from = from
		self.replyTo = replyTo
		self.to = to
		self.cc = cc
		self.bcc = bcc
		self.subject = subject
		self.tag = tag
		self.body = body
		self.attachments = attachments
	}
	
	public var json:[String:Any] {
		var params:[String:Any] = [
			"From" : from.formatted
			,"To":to.map{$0.formatted}.joined(separator:",")
		]
		params["Cc"] = cc.flatMap{$0.map{$0.formatted}.joined(separator: ",")}
		params["Bcc"] = bcc.flatMap{$0.map{$0.formatted}.joined(separator: ",")}
		params["Subject"] = subject
		params["Tag"] = tag
		params["HtmlBody"] = body.html
		params["TextBody"] = body.text
		params["ReplyTo"] = replyTo?.formatted
		params["Attachments"] = attachments.flatMap{$0.map{$0.json}}
		return params
	}
	
	
}



