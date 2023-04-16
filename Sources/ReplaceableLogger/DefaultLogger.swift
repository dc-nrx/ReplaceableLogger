//
//  File.swift
//
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

/**
 A simple default implementation for `Logger` protocol.
 
 The main features are:
 - Logging implemented via standard `print` function.
 - Ignores all messages with a level lower than `minimumLogLevel` (which, in turn, can be set in multiple ways - see the `minimumLogLevel` doc for details).
 - Can add prefixes - both universal (e.g. "=>") and level-based (e.g. "⚠️" for warnings) - see `commonPrefix` and `levelPrefixes`
 - When the time comes, can be easily substituted with a more powerful solution (such as CocoaLumberjack).
 */
public class DefaultLogger: Logger {
	
	/**
	 Set an env variable under this key with one of `LogLevel` raw values.
	 
	 - Warning:
	 If not nil, `customLogLevel` parameter passed to `init` overrides the env setting.
	 */
	public static let logLevelEnvKey = "SWIFT_NETWORKING_LOG_LEVEL"
	
	/**
	 The minimul log level. All messages with a lower level will not be logged.
	 */
	public var minimumLogLevel: LogLevel

	/**
	 Added at the very beginnig of each message.
	 */
	public var commonPrefix: String?

	/**
	 Added after `commonPrefix` to each message with corresponding log level.
	 */
	public var levelPrefixes: [LogLevel: String]?
	
	/**
	 The log level can be set either directly as `logLevel` parameter on init, or as `SWIFT_NETWORKING_LOG_LEVEL` env. variable value.
	 
	 The input parameter has priority over env. variable setting.
	 
	 If neither is set, the log level is set to `.debug` for DEBUG builds and to `.none` otherwise.
	 */
	public init(
		_ customLogLevel: LogLevel? = nil,
		levelPrefixes: [LogLevel: String]? = [.warning: "⚠️", .error: "❌"],
		commonPrefix: String? = nil
	) {
		self.levelPrefixes = levelPrefixes
		self.commonPrefix = commonPrefix
		
		if let customLogLevel = customLogLevel {
			self.minimumLogLevel = customLogLevel
		} else if let envDefinedLogLevelString = ProcessInfo.processInfo.environment[DefaultLogger.logLevelEnvKey],
				  let envDefinedLogLevel = LogLevel(rawValue: envDefinedLogLevelString) {
			self.minimumLogLevel = envDefinedLogLevel
		} else {
			#if DEBUG
			self.minimumLogLevel = .debug
			#else
			self.minimumLogLevel = .force
			#endif
		}
	}
	
	public func log(
		_ level: LogLevel,
		_ message: String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		if level >= minimumLogLevel {
			let prefix = messagePrefix(level)
			unconditionalLog("\(prefix)\(message)")
		}
	}

	/**
	 Moved to a separate internal method for unit testing purposes.
	 */
	func unconditionalLog(_ message: String) {
		print(message)
	}
	
	private func messagePrefix(_ logLevel: LogLevel) -> String {
		var prefix = ""
		if let commonPrefix {
			prefix += commonPrefix + " "
		}
		if let levelPrefix = levelPrefixes?[logLevel] {
			prefix += levelPrefix + " "
		}
		return prefix
	}
}
