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
 - When the time comes, easily substituted with a more powerful solution (e.g. CocoaLumberjack).
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
	
	public var options: LogOptions
	/**
	 The log level can be set either directly as `logLevel` parameter on init, or as `SWIFT_NETWORKING_LOG_LEVEL` env. variable value.
	 
	 The input parameter has priority over env. variable setting.
	 
	 If neither is set, the log level is set to `.debug` for DEBUG builds and to `.none` otherwise.
	 */
	public init(
		_ customLogLevel: LogLevel? = nil,
		options: LogOptions = [.timestamp],
		levelPrefixes: [LogLevel: String]? = [.warning: "⚠️", .error: "❌"],
		commonPrefix: String? = nil
	) {
		self.levelPrefixes = levelPrefixes
		self.commonPrefix = commonPrefix
		self.options = options
		
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
		message: @autoclosure () -> String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		if level >= minimumLogLevel {
			let prefix = messagePrefix(level)
			let optional = optionalInfo(file: file, function: function, line: line)
			unconditionalLog("\(optional)\(prefix)\(message())")
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

// MARK: - Private
private extension DefaultLogger {

	func optionalInfo(file: String, function: String, line: Int) -> String {
		var result = ""
		
		if options.contains(.timestamp) {
			let df = DateFormatter()
			df.dateFormat = "mm:ss.SSS"
			let timeString = df.string(from: .now)
			result.append(timeString)
		}
		
		if options.contains(.filename) {
			let fileMaxLen = 15
			let lastComponent: String = String(URL(string: file)?.lastPathComponent.prefix { $0 != "." } ?? "")
			let lastComponentShortened = shortened(lastComponent, max: fileMaxLen - 2) // 2 for brackets
			let lastPathComponentHighlighted = "[\(lastComponentShortened)]"
			let fileUtf8 = (lastPathComponentHighlighted as NSString).utf8String!
			result = result.appendingFormat(" %-\(fileMaxLen)s", fileUtf8)
		}
		
		if options.contains(.function) {
			let funMaxLen = 20
			let funAdjusted: String = shortened(function, max: funMaxLen)
			let funUtf8 = (funAdjusted as NSString).utf8String!
			result = result.appendingFormat(" %-\(funMaxLen)s", funUtf8)
		}
		
		if options.contains(.line) {
			result += ":\(line)"
		}
		
		if !result.isEmpty {
			result += ": "
		}
		
		return result
	}
	
	func shortened(_ str: String, max maxLen: Int) -> String {
		let prefixLen = max(maxLen - 3, 0)
		if str.count > maxLen {
			return str.prefix(prefixLen) + "..."
		} else {
			return str
		}
	}
}
