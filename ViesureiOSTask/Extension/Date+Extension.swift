//
//  Date+Extension.swift
//  ViesureTask
//
//  Created by Mohamed El-Shawarby on 22.06.22.
//

import Foundation

extension Date {

    var veisureStringFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = """
                                EEE, MMM d, ''yy
                                """
        return dateFormatter.string(from: self)
    }
}
