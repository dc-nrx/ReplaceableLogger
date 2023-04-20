//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import Foundation

public struct LogOptions: OptionSet {
	
	public static let timestamp = LogOptions(rawValue: 1 << 0)
	public static let filename = LogOptions(rawValue: 1 << 1)
	public static let function = LogOptions(rawValue: 1 << 2)
	public static let line = LogOptions(rawValue: 1 << 3)

	public let rawValue: Int
	public init(rawValue: Int) {
		self.rawValue = rawValue
	}
}

public enum LogLevel: String, CaseIterable, Comparable {

	case verbose
	case debug
	case info
	case warning
	case error
	case fatal

	public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
		return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
	}
}


