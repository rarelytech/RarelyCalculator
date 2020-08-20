//
//  Extensions.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/18.
//

import Foundation


extension String {
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start ..< end])
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[startIndex...endIndex])
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func matchGroup(_ pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            
            let match = matches[0]
            let rangeBounds = match.range(at: 1)
            guard let range = Range(rangeBounds, in: self) else {
                return [""]
            }
            return String(self[range]).split(separator: "\n").map(String.init)
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
