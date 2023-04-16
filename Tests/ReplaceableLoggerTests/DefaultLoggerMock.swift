//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import Foundation
@testable import ReplaceableLogger
	
final class DefaultLoggerMock: DefaultLogger {
	
	var lastMessage: String? = nil
	
	override func unconditionalLog(_ message: String) {
		super.unconditionalLog(message)
		lastMessage = message
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
	
	static var sampleLevelPrefixesDict: [LogLevel: String] {
		allCases.reduce(into: [:]) { $0[$1] = $1.sampleLevelPrefix }
	}
	
	var sampleLevelPrefix: String {
		switch self {
		case .verbose:
			return "[VERBOSE]"
		case .debug:
			return "[DEBUG]"
		case .info:
			return "[INFO]"
		case .warning:
			return "[WARNING]"
		case .error:
			return "[ERROR]"
		case .fatal:
			return "[FATAL"
		}
	}
}
