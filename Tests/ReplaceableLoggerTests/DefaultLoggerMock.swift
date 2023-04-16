//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import Foundation
@testable import ReplaceableLogger
	
final class DefaultLoggerMock: DefaultLogger {
	
	var logIntercept: ((String) -> ())!
	
	override func unconditionalLog(_ message: String) {
		super.unconditionalLog(message)
		
		logIntercept(message)
	}
}

extension LogLevel {
	
	var sampleMessage: String {
		switch self {
		case .verbose:
			return "verbose sample message"
		case .debug:
			return "debug sample message"
		case .info:
			return "info sample message"
		case .warning:
			return "warning sample message"
		case .error:
			return "error sample message"
		case .fatal:
			return "fatal sample message"
		}
	}
}
