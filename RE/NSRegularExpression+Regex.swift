//
//  NSRegularExpression+Regex.swift
//  Shopline Merchant app
//
//  Created by Henry Tseng on 2017/6/29.
//  Copyright © 2017年 Starling Labs. All rights reserved.
//

import Foundation

public typealias RE = NSRegularExpression

extension RE {
    public convenience init(_ pattern: String) throws {
        let reg = try NSRegularExpression(pattern: "^/(.+)/([gismx]*)$", options: .caseInsensitive)

        var formatPattern: String!
        var options: NSRegularExpression.Options = []

        if let match = reg.firstMatch(in: pattern, options: [], range: NSMakeRange(0, pattern.count)) {
            let optionText = (pattern as NSString).substring(with: match.range(at: 2))
            for c in optionText {
                switch c {
                case "i":
                    options.insert(.caseInsensitive)
                case "s":
                    options.insert(.dotMatchesLineSeparators)
                case "m":
                    options.insert(.anchorsMatchLines)
                case "x":
                    options.insert(.allowCommentsAndWhitespace)
                default: ()
                }
            }
            formatPattern = (pattern as NSString).substring(with: match.range(at: 1))
        } else {
            formatPattern = pattern
        }
        try self.init(pattern: formatPattern, options: options)
    }
    
    public func matches(text: String) -> [[String]] {
        let matches = self.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        var matchStrings = [[String]]()
        for match in matches {
            let count = match.numberOfRanges
            var strings = [String]()
            for i in 0..<count {
                let range = match.range(at: i)
                if range.location != NSNotFound {
                    let string = (text as NSString).substring(with: range)
                    strings.append(string)
                }
            }
            matchStrings.append(strings)
        }
        return matchStrings
    }
    
    public func replace(text: String, with replacement: String) -> String {
        let matches = self.matches(in: text, options: [], range: NSMakeRange(0, text.utf16.count))
        var replacedString = text
        for match in matches.reversed() {
            let fullReplaceRange = match.range(at: 0)
            replacedString = (replacedString as NSString).replacingCharacters(in: fullReplaceRange, with: replacement)
            if match.numberOfRanges > 1 {
                var parameters = [String]()
                for i in 1..<match.numberOfRanges {
                    let paramRange = match.range(at: i)
                    if paramRange.location != NSNotFound {
                        let param = (text as NSString).substring(with: paramRange)
                        parameters.append(param)
                    }
                }
                replacedString = String(format: replacedString, arguments: parameters)
            }
        }
        return replacedString
    }
}
