//
//  JsonDecoder+Extension.swift
//  ViesureTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import Foundation

extension JSONDecoder {

    static let  appCustomJsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm/dd/yyyy"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()
}
