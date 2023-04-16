

import XCTest
@testable import ReplaceableLogger

final class ReplaceableLoggerTests: XCTestCase {
		
    func testInit_withDefaultValues_hasDebugLevel() throws {
		let sut = DefaultLogger()
		XCTAssertEqual(sut.logLevel, .debug)
    }
	
	func testInit_minLogLevelVerbose_logsEveryLevel() throws {
		let sut = DefaultLoggerMock(.verbose)
		var lastMessage = ""
		sut.logIntercept = { lastMessage = $0 }
		
		sut.log(.fatal, LogLevel.fatal.sampleMessage)
		XCTAssertEqual(lastMessage, LogLevel.fatal.sampleMessage)
		
		sut.log(.error, LogLevel.error.sampleMessage)
		XCTAssertEqual(lastMessage, LogLevel.error.sampleMessage)
		
		sut.log(.warning, LogLevel.warning.sampleMessage)
		XCTAssertEqual(lastMessage, LogLevel.warning.sampleMessage)
		
		sut.log(.info, LogLevel.info.sampleMessage)
		XCTAssertEqual(lastMessage, LogLevel.info.sampleMessage)
		
		sut.log(.debug, LogLevel.debug.sampleMessage)
		XCTAssertEqual(lastMessage, LogLevel.debug.sampleMessage)
		
		sut.log(.verbose, LogLevel.verbose.sampleMessage)
		XCTAssertEqual(lastMessage, LogLevel.verbose.sampleMessage)
	}

	func testInit_minLogLevelFatal_logsFatalOnly() throws {
		let sut = DefaultLoggerMock(.fatal)
		var lastMessage = ""
		sut.logIntercept = { lastMessage = $0 }
		let specificFatalMessage = "specific fatal message"
		
		sut.log(.fatal, "specific fatal message")
		XCTAssertEqual(lastMessage, specificFatalMessage)

		for level in LogLevel.allCases.dropLast() {
			sut.log(level, LogLevel.error.sampleMessage)
			XCTAssertEqual(lastMessage, specificFatalMessage)
		}
	}
	
}
