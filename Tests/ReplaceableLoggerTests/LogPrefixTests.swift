//
//  LogPrefixTests.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import XCTest
@testable import ReplaceableLogger

final class LogPrefixTests: XCTestCase {
	
    func testCommonPrefix_addedToAllLevels() throws {
		let commonPrefix = "XX"
		let sut = DefaultLoggerMock(.verbose, commonPrefix: commonPrefix)		
		for level in LogLevel.allCases {
			sut.log(level, level.sampleMessage)
			AssertContainsSubstring(sut.lastMessage, commonPrefix)
		}
    }

	func testLevelPrefixes_addedToCorrespondingLevels() throws {
		let levelPrefixes = LogLevel.sampleLevelPrefixesDict
		let sut = DefaultLoggerMock(.verbose, levelPrefixes: levelPrefixes)
		for level in LogLevel.allCases {
			sut.log(level, level.sampleMessage)
			AssertContainsSubstring(sut.lastMessage, level.sampleLevelPrefix)
		}
	}
	
	func testSpacesAndOrder_between_commonPrefix_levelPrefix_andMessage() {
		let levelPrefixes = LogLevel.sampleLevelPrefixesDict
		let message = "message_without_spaces"
		let commonPrefix = "zzz"
		let sut = DefaultLoggerMock(.verbose,
									levelPrefixes: levelPrefixes,
									commonPrefix: commonPrefix)
		for level in LogLevel.allCases {
			sut.log(level, message)
			let components = sut.lastMessage?.components(separatedBy: " ") ?? []
			XCTAssertEqual(components.count, 3, "message: \(sut.lastMessage ?? "<nil>")")
			XCTAssertEqual(components[0], commonPrefix)
			XCTAssertEqual(components[1], levelPrefixes[level])
			XCTAssertEqual(components[2], message)
		}
	}

	func testSpaces_between_commonPrefix_andMessage_noLevelPrefixes() {
		let sut = DefaultLoggerMock(.verbose,
									levelPrefixes: nil,
									commonPrefix: "zzz")
		for level in LogLevel.allCases {
			sut.log(level, "message_without_spaces")
			let components = sut.lastMessage?.components(separatedBy: " ") ?? []
			XCTAssertEqual(components.count, 2, "message: \(sut.lastMessage ?? "<nil>")")
		}
	}

	func testSpaces_between_levelPrefixes_andMessage_noCommonPrefix() {
		let sut = DefaultLoggerMock(.verbose,
									levelPrefixes: nil,
									commonPrefix: "zzz")
		for level in LogLevel.allCases {
			sut.log(level, "message_without_spaces")
			let components = sut.lastMessage?.components(separatedBy: " ") ?? []
			XCTAssertEqual(components.count, 2, "message: \(sut.lastMessage ?? "<nil>")")
		}
	}
}
