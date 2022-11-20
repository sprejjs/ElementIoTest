//
//  CronInput.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import Foundation

/// Representation of CronTimeUnit, could be either an integer or any "any" value.
enum CronTimeUnit: Equatable {
  case number(Int)
  case any
}

/// Representation of parts of Cron input
protocol CronInput {
  var hour: CronTimeUnit { get }
  var minute: CronTimeUnit { get }
  var command: String { get }
}

/// Extracted elements of cron input.
struct CronInputImpl: CronInput {
  /// The hour of the day. Either an integer from 0 to 24 or any hour.
  public let hour: CronTimeUnit
  /// The minute of the day. Either an integer from 0 to 59 or any minute.
  public let minute: CronTimeUnit
  /// The name of the command to be executed. Has to be present, but not validated.
  public let command: String

  /// Optional initialiser that constructs an object from provided input in the following format: `X Y Z`, where X is the minute of an hour, Y is the hour of the day, and Z is the command name.
  ///
  /// The hour has to be either an integer between 0 and 23 or the `*` sybmol representing any hour.
  /// The minute has to be either an integer between 0 and 59 or the `*` sybmol representing any minute.
  /// The command has to be present by it's not validated.
  ///
  /// All elements have to be separated by whitespace characters (either tabs or spaces).
  ///
  /// The initialiser returns `nil` if the input is not valid.
  /// - Parameter input: Command in the specified input.
  public init?(input: String) {
    let components = input.components(separatedBy: .whitespaces)

    guard
      components.count == 3,
      let minute = CronInputImpl.timeElementFromString(
        components[safe: 0],
        elementType: .minute),
      let hour = CronInputImpl.timeElementFromString(
        components[safe: 1],
        elementType: .hour),
      let command = components.last
    else {
      return nil
    }

    self.hour = hour
    self.minute = minute
    self.command = command
  }

  /// Supplimentary function converting an optional string to either a CronTimeUnit or `nil` if the input is invalid.
  ///
  /// - Parameters:
  ///   - string: input of the function. Has to either contain the `*` chracter indicating any value or an integer between the lower and upper bounds inclusive.
  ///   - lowerBound: lowest valid value for the supplied integer inclusive.
  ///   - upperBound: highest valid value for the supplied ingetger inclusive.
  /// - Returns: validated CronTimeUnit or `nil`.
  static func timeElementFromString(
    _ string: String?,
    elementType: TimeElementParser.ElementType) -> CronTimeUnit? {
    guard let string else {
      return nil
    }
    if string == Constants.anyCharacter {
      return .any
    }

    guard
      let number = TimeElementParser.timeElementFromString(
        string, elementType: elementType)
    else {
      return nil
    }

    return .number(number)
  }

  private enum Constants {
    static let anyCharacter = "*"
  }
}
