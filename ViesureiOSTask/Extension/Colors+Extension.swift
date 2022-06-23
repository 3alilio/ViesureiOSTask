//
//  Colors+Extension.swift
//  
//
//  Created by Mohamed El-Shawarby on 24.05.22.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    var color: Color {
        if #available(iOS 15.0, *) {
            return Color(uiColor: self)
        } else {
            return Color(self)
        }
    }
}
