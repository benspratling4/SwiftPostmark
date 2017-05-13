//
//  TestServerSendTests.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation
@testable import SwiftPostmark
import Dispatch
import XCTest


class TestServerSendTests : XCTestCase {
	
	func testSendingFakeMessage() {
		
		guard let toAddress:Address = try? Address(address: "me@example.com", name: "Despicable Me")
			,let fromAddress:Address = try? Address(address: "me+1@example.com", name: "Despicable Me 1")
			else {
			XCTFail("unable to parse email address")
			return
		}
		
		guard let message = try? Message(from: fromAddress, to: [toAddress], subject: "test", body: .text("This is a text, a what? a test.  Oh a test."))
			else {
				XCTFail("validating message failed")
				return
		}
		
		let server:Server = Server.testServer()
			
		let request:URLRequest = server.requestForSendingMessage(message)
		
		let session = URLSession(configuration: .default)
		
		let responseExpectation = expectation(description: "response")
		
		var messageID:String?
		let task = session.dataTask(with: request) { (dataOrNil, responseOrNil, errorOrNil) in
			if let error = errorOrNil {
				print(error)
				XCTFail("network failure")
				return
			}
			guard let response = SendMessageResponse.messageResponse(urlResponse: responseOrNil, body: dataOrNil) else {
				XCTFail("no valid response from server")
				return
			}
			if let sendResponse:SendMessageResponse = response as? SendMessageResponse {
				messageID = sendResponse.messageID
				if let id = messageID {
					print("message id = \(id)")
				}
				responseExpectation.fulfill()
				
			} else {
				print(response)
				XCTFail("didn't get message response")
				return
			}
			
		}
		task.resume()
		waitForExpectations(timeout: 10.0, handler: nil)
		
	}
	
	
}
