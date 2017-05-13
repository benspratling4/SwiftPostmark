//
//  Address.swift
//  SwiftPostmark
//
//  Created by Ben Spratling on 5/13/17.
//
//

import Foundation
///represents a combination of an email address and a name
public struct Address {
	
	public enum AddressError : Error {
		case invalidEmailAddress
	}
	
	public var name:String?
	
	public var address:String
	
	static let invalidDomainCharacterSet:CharacterSet = { ()->(CharacterSet) in
		var set:CharacterSet = CharacterSet(charactersIn: "[]():.-")
		set.insert(charactersIn: "a"..."z")
		set.insert(charactersIn: "A"..."Z")
		set.insert(charactersIn: "0"..."9")
		set.insert(charactersIn: UnicodeScalar(UInt8(0x7F))...UnicodeScalar(UInt32(0xD7FF))!)
		set.insert(charactersIn: UnicodeScalar(UInt32(0xE000))!...UnicodeScalar(UInt32(0x10FFFF))!)
		return set.inverted
	}()
	
	static let invalidLocalCharacterSet:CharacterSet = { ()->(CharacterSet) in
		var set:CharacterSet = CharacterSet(charactersIn: "!#$%&'*+-/=?^_`{|}~.")
		set.insert(charactersIn: "a"..."z")
		set.insert(charactersIn: "A"..."Z")
		set.insert(charactersIn: "0"..."9")
		set.insert(charactersIn: UnicodeScalar(UInt8(0x7F))...UnicodeScalar(UInt32(0xD7FF))!)
		set.insert(charactersIn: UnicodeScalar(UInt32(0xE000))!...UnicodeScalar(UInt32(0x10FFFF))!)
		return set.inverted
	}()
	
	/// may throw Address.AddressError
	/// checks local and domain of address for invalid characters (international characters are allowed)
	/// does not check more complex, like leading or trailing . or -, or numeric-only TLD
	/// quoted addresses are not permitted at this time.
	/// approximating RFC 6530 https://tools.ietf.org/html/rfc6530
	public init(address:String, name:String? = nil)throws {
		let components = address.components(separatedBy: "@")
		guard components.count == 2 else {
			throw AddressError.invalidEmailAddress
		}
		let local:String = components[0]
		if local.rangeOfCharacter(from: Address.invalidLocalCharacterSet) != nil {
			throw AddressError.invalidEmailAddress
		}
		let domain:String = components[1]
		if domain.rangeOfCharacter(from:Address.invalidDomainCharacterSet) != nil {
			throw AddressError.invalidEmailAddress
		}
		self.name = name
		self.address = address
	}
	
	public var formatted:String {
		if let name = self.name {
			return "\"\(name)\" <\(address)>"
		} else {
			return address
		}
	}
}
