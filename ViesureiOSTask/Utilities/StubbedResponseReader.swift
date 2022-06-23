//
//  StubbedResponseReader.swift
//
//  Created by Mohamed El-Shawarby on 23.05.22.
//

import Foundation

class StubbedResponseReader {

    static func getResponseData(fileName: String, bundle: Bundle = Bundle.main) -> Data {
        guard let url = bundle.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
}
