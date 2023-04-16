//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import Foundation
import XCTest

func AssertContainsSubstring(
	_ string: String?,
	_ substring: String,
	customMessage: String? = nil
) {
	guard let string else {
		XCTFail("The `string` parameter is nil => does not contain \(substring)")
		return
	}
	XCTAssertTrue(string.contains(substring), customMessage ?? "'\(string)' does not containt '\(substring)'")
}
