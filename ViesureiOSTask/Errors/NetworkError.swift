//
//  NetworkError.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import Foundation
import Moya
import Alamofire

struct NetworkError: PresentableError {

    var title = NSLocalizedString("Network Error", comment: "")
    var description = ""
    var isRetriable = true

    mutating func setDescripiton(for error: URLError) {
        switch error.code {
        case .timedOut:
            description = NSLocalizedString("Request timed out. Make sure your internet connection is working properly and try again later.", comment: "")
        case .notConnectedToInternet:
            description = String(format: NSLocalizedString("No internet connection. Make sure your %@ is connected to the internet to continue.", comment: ""), UIDevice.current.localizedModel)
        default:
            description = NSLocalizedString("An unknown error occurred while trying to connect to our servers.", comment: "")
        }
    }

    init?(error: Error) {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .underlying(let error, _):
                guard let afError = error as? AFError, let error = afError.underlyingError as? URLError else { return nil }
                self.setDescripiton(for: error)
            default:
                return nil
            }
        } else if let networkError = error as? URLError {
            self.setDescripiton(for: networkError)
        } else {
            return nil
        }
    }
}
