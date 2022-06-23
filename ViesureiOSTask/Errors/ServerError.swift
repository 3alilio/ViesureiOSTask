//
//  ServerError.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import Foundation
import Moya

struct ServerError: PresentableError {

    var isRetriable = true

    init?(error: Error) {
        guard let moyaError = error as? MoyaError, moyaError.response?.statusCode == 500 else { return nil }
    }
}
