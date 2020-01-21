//
//  String+Ext.swift
//  FisherMan
//
//  Created by Yura Granchenko on 21.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public var URL: Foundation.URL? {
        return Foundation.URL(string: self as String)
    }
    
    public var fileURL: Foundation.URL? {
        return Foundation.URL(fileURLWithPath: self as String)
    }
    
    public var smartURL: Foundation.URL? {
        if isExistingFilePath {
            return fileURL
        } else {
            return URL
        }
    }
    
    public var isExistingFilePath: Bool {
        if hasPrefix("http") {
            return false
        }
        return FileManager.default.fileExists(atPath: self as String)
    }
    
    public var trim: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    fileprivate static let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&" +
        "'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|" +
        "\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9]" +
        "(?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4]" +
        "[0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-" +
    "\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    public var isValidEmail: Bool {
        guard let predicate = try? NSRegularExpression(pattern: String.emailRegex,
                                                       options: []) else { return false }
        return predicate.firstMatch(in: self,
                                    options: [],
                                    range: NSMakeRange(0, count - 1)) != nil
    }
    
    public var isValidPhone: Bool {
        let phoneNumber = NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        guard let detector = try? NSDataDetector(types: phoneNumber) else { return false }
        
        if let match = detector.matches(in: self as String,
                                        options: [],
                                        range: NSMakeRange(0, (self as String).count)).first?.phoneNumber {
            return match == self as String
        } else {
            return false
        }
    }
    
    public var URLQuery: [String: String] {
        
        var parameters = [String: String]()
        for pair in components(separatedBy: "&") {
            let components = pair.components(separatedBy: "=")
            if components.count == 2 {
                parameters[components[0]] = components[1].removingPercentEncoding
            } else {
                continue
            }
        }
        return parameters
    }
    
    private func clearPhoneNumber() -> String {
        var phone = ""
        for character in (self as String) {
            if character == "+" || "0"..."9" ~= character {
                phone.append(character)
            }
        }
        return phone
    }
    
    public var ls: String {
        let string = self as String
        return Bundle.main.localizedString(forKey: string, value: string, table: nil)
    }
    
    private func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var result = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let characterIndex = index(startIndex, offsetBy: randomIndex)
            result += String(characters[characterIndex])
        }
        return result
    }
    
    private var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    public func heightWithFont(_ font: UIFont, width: CGFloat) -> CGFloat {
        if isEmpty { return 0.0 }
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let height = self.boundingRect(with: size,
                                       options: .usesLineFragmentOrigin,
                                       attributes: [.font: font],
                                       context: nil).height
        return ceil(height)
    }
    
    public var localized: String {
        return localized(for: LanguageManager.shared.bundle)
    }
    
    public func localized(for bundle: Bundle) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
    
    public var numbers: String {
        return String(filter { "0"..."9" ~= $0 })
    }
    
    public func removeWhitespacesPattern() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    public func subString(by pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        return regex?.matches(in: self, options: [], range: NSRange(location: 0, length: count)).map({
            self[Range($0.range, in: self)!].toString()
        }).first
    }
    
    public func removeSubstring(by pattern: String) -> String {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let output = regex?.stringByReplacingMatches(in: self,
                                                     options: [],
                                                     range: NSRange(location: 0, length: count),
                                                     withTemplate: "")
        return output ?? ""
    }
    
    public func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    public func applyPattern() -> String {
        return applyPatternOnNumbers(pattern: "## ### ####",
                                     replacmentCharacter: "#")
    }
    
    private func findIndexes(in string: String, isSearhing: Bool) -> [Int] {
        var indexes = [Int]()
        var searchStartIndex = startIndex
        while startIndex < endIndex, let range = range(of: string,
                                                       options: .caseInsensitive,
                                                       range: searchStartIndex..<endIndex),
            !range.isEmpty {
                if !isSearhing && string.contains("Bit") {
                    let _index = index(range.upperBound, offsetBy: 0)
                    if _index.encodedOffset < self.count, self[_index] == "b" {
                        let index = distance(from: startIndex, to: range.lowerBound)
                        indexes.append(index)
                    }
                } else {
                    let index = distance(from: startIndex, to: range.lowerBound)
                    indexes.append(index)
                }
                searchStartIndex = range.upperBound
        }
        return indexes
    }
    
    private var utfData: Data? {
        return data(using: .utf8)
    }
    
    public var attributedHtmlString: NSAttributedString? {
        guard let data = utfData else { return nil }
        do { return try NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue ],
                                           documentAttributes: nil)
        } catch { return nil }
    }
}

extension Hashable {
    public func toString() -> String {
        return "\(self)"
    }
}
