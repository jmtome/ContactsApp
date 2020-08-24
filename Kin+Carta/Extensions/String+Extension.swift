//
//  String+Extension.swift
//  Kin+Carta
//
//  Created by Juan Manuel Tome on 22/08/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation

extension String {

    /// Handles 10 or 11 digit phone numbers
    ///
    /// - Returns: formatted phone number or original value
    public func toPhoneNumber() -> String {
        let digits = self.digitsOnly
        if digits.count == 10 {
            return digits.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1)-$2-$3", options: .regularExpression, range: nil)
        }
        else if digits.count == 11 {
            return digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d+)", with: "$1($2)-$3-$4", options: .regularExpression, range: nil)
        }
        else {
            return self
        }
    }
}

extension StringProtocol {
    /// Returns the string with only [0-9], all other characters are filtered out
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }
}
