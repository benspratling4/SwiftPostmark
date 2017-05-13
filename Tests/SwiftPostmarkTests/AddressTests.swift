//
//  AddressTests.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation
import XCTest
@testable import SwiftPostmark

class AddressTests : XCTestCase {
	
	
	let validAddresses:[String] = [
		"hero.123@exampledomain.com"
		,"hero.123+1@exampledomain.com"
	]
	
	let invalidAddresses:[String] = [
		"\"hero.123\"@exampledomain.com"
		,"hero.123\\1@exampledomain.com"
	]
	
	
	func testEmailValidation() {
		
		for string in validAddresses {
			guard let _ = try? Address(address: string) else {
				XCTFail("should have parsed \(string)")
				return
			}
		}
		
		for string in invalidAddresses {
			let result:Address? = try? Address(address: string)
			guard result == nil else {
				XCTFail("should not have parsed \(string)")
				return
			}
		}
		
		
		
	}
	
	
}

