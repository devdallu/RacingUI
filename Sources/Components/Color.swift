//
//  File.swift
//  RacingUI
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 23/11/24.
//

import Foundation
import SwiftUICore
import UIKit

extension Color {
    static func fromBundle(named name: String, bundle: Bundle = .main) -> Color {
        if let uiColor = UIColor(named: name, in: bundle, compatibleWith: nil) {
            return Color(uiColor)
        } else {
            return Color.red // Fallback color
        }
    }
}
