//
//  PresentableErrorProvider.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import Foundation

struct PresentableErrorProvider {

    private var errorTypes: [PresentableError.Type] = [NetworkError.self]

    init(additional: [PresentableError.Type] = []) {
        guard !additional.isEmpty else { return }
        errorTypes.append(contentsOf: additional)
    }

    func presentableError(for error: Error) -> PresentableError {
        for type in errorTypes {
            if let presentable = type.init(error: error) {
                return presentable
            }
        }
        return UnknownError(error: error)!
    }
}
