//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 14.04.2023.
//

import Foundation

public protocol Logger {
	
	var options: [LogOptions] { get }
	
	func log(
		_ level: LogLevel,
		_ message: String,
		file: String,
		function: String,
		line: Int
	)
}

public extension Logger {
	
	var options: [LogOptions] { [] }
	
	func log(
		_ level: LogLevel,
		_ message: String,
		file: String = #file,
		function: String = #function,
		line: Int = #line
	) {
		log(level, message, file: file, function: function, line: line)
	}
}
