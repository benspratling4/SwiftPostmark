//
//  EndpointsTests.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation
@testable import SwiftPostmark
import XCTest


class EndpointsTests : XCTestCase {
	
	func testURLs() {
		XCTAssertEqual(Server.rootURL.absoluteString, "https://api.postmarkapp.com")
		XCTAssertEqual(Server.emailURL.absoluteString, "https://api.postmarkapp.com/email")
		XCTAssertEqual(Server.batchEmailURL.absoluteString, "https://api.postmarkapp.com/email/batch")
	}
	
}
