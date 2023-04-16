//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import Foundation

public struct LogOptions: OptionSet {
	
	public static let showResponseHeaders = LogOptions(rawValue: 1 << 0)
	
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
	case nothing

	public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
		let all = LogLevel.allCases
		return all.firstIndex(of: lhs)! < all.firstIndex(of: rhs)!
	}
}
