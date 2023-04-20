//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public protocol Logger {
	
	func log(
		_ level: LogLevel,
		_ message: @autoclosure () -> String,
		file: String,
		function: String,
		line: Int
	)
}

public extension Logger {
	
	func log(
		_ level: LogLevel,
		_ message: @autoclosure () -> String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		log(level, message(), file: file, function: function, line: line)
	}
}
