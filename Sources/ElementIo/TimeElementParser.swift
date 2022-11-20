//
//  File.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import Foundation

struct TimeElementParser {
  enum ElementType {
    case hour
    case minute

    var upperBound: Int {
      switch self {
      case .hour: return Constants.Hour.upperBound
      case .minute: return Constants.Minute.upperBound
      }
    }

    var lowerBound: Int {
      switch self {
      case .hour: return Constants.Hour.lowerBound
      case .minute: return Constants.Minute.lowerBound
      }
    }

    private enum Constants {
      enum Hour {
        static let lowerBound: Int = 0
        static let upperBound: Int = 23
      }
      enum Minute {
        static let lowerBound: Int = 0
        static let upperBound: Int = 59
      }
    }
  }
  /// Supplimentary function that validates an optional integer ensuring that it contains a value between lower and upper bounds inclusive. Returns `nil` if the supplied integer doesn't match the validation parameters.
  /// - Parameters:
  ///   - input: Optional integer containing a value to be validated.
  ///   - elementType: The type of element to parse. Either hour or minute.
  /// - Returns: validated integer or `nil`.
  static func timeElementFromInt(_ input: Int?, elementType: ElementType) -> Int? {
    guard let input, input <= elementType.upperBound, input >= elementType.lowerBound else { return nil}

    return input
  }

  /// Supplimentary function that parses an optional string to a validated integer ensuring that it contains a value between lower and upper bounds inclusive. Returns `nil` if the supplied value doesn't match the validation parameters.
  /// - Parameters:
  ///   - string: Optional string containing an integer value. Ignores leading zeros.
  ///   - elementType: The type of element to parse. Either hour or minute.
  /// - Returns: validated integer or `nil`.
  static func timeElementFromString(_ string: String?, elementType: ElementType) -> Int? {
    guard
      let string,
      let number = timeElementFromInt(Int(string), elementType: elementType)
    else {
      return nil
    }

    return number
  }
}
