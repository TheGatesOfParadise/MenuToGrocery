//
//  Extensions.swift
//  MenuToGrocery
//
//  Created by Mom macbook air on 4/17/23.
//

import Foundation
import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: .utf8) {
            print(JSONString)
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
