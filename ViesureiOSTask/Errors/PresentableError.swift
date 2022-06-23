//
//  PresentableError.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import Foundation

import  Moya

protocol PresentableError {

    var title: String { get }
    var description: String { get }
    var isRetriable: Bool { get }

    init?(error: Error)

}

extension PresentableError {

    var title: String {
        return NSLocalizedString("Unknown Error", comment: "")
    }

    var description: String {
        return NSLocalizedString("An unknown error occurred. Please try again later. If the problem persists, please contact our Article support.", comment: "")
    }

    var isRetriable: Bool {
        return false
    }
}
