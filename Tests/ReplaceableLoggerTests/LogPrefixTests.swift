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

	func testLevelPrefixes_addedToProperLevels() throws {
		let levelPrefixes = LogLevel.sampleLevelPrefixesDict
		let sut = DefaultLoggerMock(.verbose, levelPrefixes: levelPrefixes)
		for level in LogLevel.allCases {
			sut.log(level, level.sampleMessage)
			AssertContainsSubstring(sut.lastMessage, level.sampleLevelPrefix)
		}
	}
	
	
}
