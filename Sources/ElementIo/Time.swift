//
//  Time.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import Foundation

/// Time protocol. Allows keeping a simulated time togather in a simple object.
protocol Time {
  var hour: Int {get}
  var minute: Int {get}
  var date: Date? {get}
}

/// An implementation of the `Time` protocol. Creates an instance of an object by parsing the string. Allows easy access to the hour and minute of simulated time. Creates a date object from the hour and minute for easy comparisement.
struct TimeImpl: Time {
  /// The hour of the day with starting at 0 and finishing at 24.
  let hour: Int
  /// The minute of the hour starting at 0 and finishing at 59.
  let minute: Int

  /// Converts the hour and the minute to a date object for easy comparisement.
  /// Returns `nil` if an object cannot be created.
  var date: Date? {
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    return Calendar.current.date(from: components)
  }

  /// Optionail initialiser. Creates a Time object from an hour and a minute by first validating that they do not exceed the bounds. Returns `nil` if an object cannot be constructed.
  /// - Parameters:
  ///   - hour: The hour to create the object with. Has to be between 0 and 23
  ///   - minute: The minute to create an object with. Has to be between 0 and 59
  init?(hour: Int?, minute: Int?) {
    guard
      let hour = TimeElementParser.timeElementFromInt(
        hour, elementType: .hour),
      let minute = TimeElementParser.timeElementFromInt(
        minute, elementType: .minute) else {
      return nil
    }

    self.hour = hour
    self.minute = minute
  }

  /// Optional initialiser. Create a Time object by parsing a supplied string in the specified format: `x:y` where `x` is the hour, and `y` is the minute, and `:` is the separator. Each element may or may not contain a leading `0`s, i.e. `01` and `1` would both parse to `1`.
  /// Returns `nil` if object cannot be constructed.
  /// - Parameter input: String in the format `x:y` where `x` is the hour, and `y` is the minute, and `:` is the separator.
  init?(input: String?) {
    guard
      let components = input?.components(separatedBy: ":"),
      components.count == 2,
      let hour = TimeElementParser.timeElementFromString(
        components.first, elementType: .hour),
      let minute = TimeElementParser.timeElementFromString(components.last, elementType: .minute) else {
      return nil
    }

    self.hour = hour
    self.minute = minute
  }
}
