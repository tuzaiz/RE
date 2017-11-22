//
//  String+Regex.swift
//  Shopline Merchant app
//
//  Created by Henry Tseng on 2017/6/29.
//  Copyright © 2017年 Starling Labs. All rights reserved.
//

import Foundation

precedencegroup RegularExpressionPrecedence {
    associativity: left
    lowerThan: ComparisonPrecedence
    higherThan: LogicalConjunctionPrecedence
}

infix operator =~: RegularExpressionPrecedence

extension String {
    static public func =~(left: String, right: String) -> Bool {
        return try! left.matches(right).count > 0
    }
    
    static public func =~(left: String, right: RE) -> Bool {
        return right.firstMatch(in: left, options: [], range: NSMakeRange(0, left.count)) != nil
    }
    
    public func matches(_ pattern: String) throws -> [[String]] {
        let re = try RE(pattern)
        return self.matches(re)
    }
    
    public func matches(_ re: RE) -> [[String]] {
        return re.matches(text: self)
    }
    
    public func replace(_ pattern: String, with replace: String) throws -> String {
        let re = try RE(pattern)
        return self.replace(re, with: replace)
    }
    
    public func replace(_ re: RE, with replace: String) -> String {
        return re.replace(text: self, with: replace)
    }
    
    public var re: RE? {
        do {
            let re = try RE(self)
            return re
        } catch {
            return nil
        }
    }
}

