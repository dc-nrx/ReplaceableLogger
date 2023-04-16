//
//  File.swift
//  
//
//  Created by Dmytro Chapovskyi on 16.04.2023.
//

import Foundation

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
