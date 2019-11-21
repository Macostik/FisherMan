//
//  Logger.swift
//  FishWorld
//
//  Created by Yura Granchenko on 07.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit

extension UIApplication.State {
    public func displayName() -> String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "in background"
        default: return ""
        }
    }
}

struct Logger {
    
    static let logglyDestination = SlimLogglyDestination()
    
    static func configure() {
        Slim.addLogDestination(logglyDestination)
    }
    
    enum LogType: String {
        case `default` = ""
        case warning = "⚠️ Warning: "
        case info = "ℹ️ Info: "
        case error = "🔥 Error: "
        case debug = "🐞 Debug: "
        case verbose = "📣 Verbose: "
    }
    
    static func debugLog(_ string: @autoclosure () -> String,
                         type: LogType = .default,
                         filename: String = #file,
                         line: Int = #line) {
        if Environment.isDevelop {
            Slim.debug("\(type.rawValue)\(string())\n",
                filename: filename,
                line: line)
        }
    }
    
    static func log<T>(_ message: @autoclosure () -> T,
                       type: LogType = .default,
                       filename: String = #file,
                       line: Int = #line) {
        if Environment.isDevelop {
            Slim.debug("\(type.rawValue)\(message())\n",
                filename: filename,
                line: line)
        } else {
            Slim.info(message(), filename: filename, line: line)
        }
    }
    
    static func error<T>(_ message: @autoclosure () -> T,
                         filename: String = #file,
                         line: Int = #line) {
        log(message(), type: .error, filename: filename, line: line)
    }
    
    static func debug<T>(_ message: @autoclosure () -> T,
                         filename: String = #file,
                         line: Int = #line) {
        log(message(), type: .debug, filename: filename, line: line)
    }
    
    static func warrning<T>(_ message: @autoclosure () -> T,
                            filename: String = #file,
                            line: Int = #line) {
        log(message(), type: .verbose, filename: filename, line: line)
    }
    
    static func info<T>(_ message: @autoclosure () -> T,
                        filename: String = #file,
                        line: Int = #line) {
        log(message(), type: .info, filename: filename, line: line)
    }
    
    static func verbose<T>(_ message: @autoclosure () -> T,
                           filename: String = #file,
                           line: Int = #line) {
        log(message(), type: .warning, filename: filename, line: line)
    }
}
