

import XCTest
@testable import ReplaceableLogger

final class LogLevelTests: XCTestCase {
		
    func testInit_withDefaultValues_hasDebugLevel() throws {
		let sut = DefaultLogger()
		XCTAssertEqual(sut.minimumLogLevel, .debug)
    }
	
	func testInit_minLogLevelVerbose_logsEveryLevel() throws {
		let sut = DefaultLoggerMock(.verbose)
		
		sut.log(.fatal, LogLevel.fatal.sampleMessage)
		AssertContainsSubstring(sut.lastMessage, LogLevel.fatal.sampleMessage)
		
		sut.log(.error, LogLevel.error.sampleMessage)
		AssertContainsSubstring(sut.lastMessage, LogLevel.error.sampleMessage)
		
		sut.log(.warning, LogLevel.warning.sampleMessage)
		AssertContainsSubstring(sut.lastMessage, LogLevel.warning.sampleMessage)
		
		sut.log(.info, LogLevel.info.sampleMessage)
		AssertContainsSubstring(sut.lastMessage, LogLevel.info.sampleMessage)
		
		sut.log(.debug, LogLevel.debug.sampleMessage)
		AssertContainsSubstring(sut.lastMessage, LogLevel.debug.sampleMessage)
		
		sut.log(.verbose, LogLevel.verbose.sampleMessage)
		AssertContainsSubstring(sut.lastMessage, LogLevel.verbose.sampleMessage)
	}

	func testInit_minLogLevelFatal_logsFatalOnly() throws {
		let sut = DefaultLoggerMock(.fatal)
		let specificFatalMessage = "specific fatal message"
		
		sut.log(.fatal, "specific fatal message")
		AssertContainsSubstring(sut.lastMessage, specificFatalMessage)

		for level in LogLevel.allCases.dropLast() {
			sut.log(level, LogLevel.error.sampleMessage)
			AssertContainsSubstring(sut.lastMessage, specificFatalMessage)
		}
	}
	
}
