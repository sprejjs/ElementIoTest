//
//  CronJobNextDateCommandParser.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import Foundation


/// CronJobNextDateCommandParser receives the command in a simplified cron syntax as well as the simulated time and then returns a string indicating when the command is going to be executed next.
/// Returns `nil` if the input is invalid.
protocol CronJobNextDateCommandParser {

  /// Returns the string of the next command execution date and time.
  /// - Parameters:
  ///   - command: Command in the simplified cron syntax, e.g. `15 * /bin/command`
  ///   - simulatedTime: The simulated time to compare against the cron syntax
  /// - Returns: Either the next execution string or `nil` if the input is invalid.
  func nextDateForCommand(_ command: String, simulatedTime: Time) -> String?
}

struct CronJobNextDateCommandParserImpl: CronJobNextDateCommandParser {

  /// Returns the string of the next command execution date and time.
  /// - Parameters:
  ///   - command: Command in the simplified cron syntax, e.g. `15 * /bin/command`
  ///   - simulatedTime: The simulated time to compare against the cron syntax
  /// - Returns: Either the next execution string or `nil` if the input is invalid.
  func nextDateForCommand(_ string: String, simulatedTime: Time) -> String? {
    guard let cronJob = CronInputImpl(input: string) else {
      return nil
    }

    if case .number(let hour) = cronJob.hour, case .number(let minute) = cronJob.minute {
      guard let expectedTime = TimeImpl(hour: hour, minute: minute) else { return nil }

      return nextDateForCommandWithSpecificTime(
        expectedTime: expectedTime,
        simulatedTime: simulatedTime,
        commandName: cronJob.command)
    }

    if case .number(let hour) = cronJob.hour, cronJob.minute == .any {
      return nextDateForCommandWithSpecificHour(hour: hour, simulatedTime: simulatedTime, commandName: cronJob.command)
    }

    if cronJob.hour == .any, case .number(let minute) = cronJob.minute {
      return nextDateForCommandWithSpecificMinute(minute: minute, simulatedTime: simulatedTime, commandName: cronJob.command)
    }

    return nextDateForCommandWithAnyTime(simulatedTime: simulatedTime, commandName: cronJob.command)
  }


  /// Parses the simplified cron syntax with a specific date and time.
  /// - Parameters:
  ///   - expectedTime: Expected time the command should run.
  ///   - simulatedTime: The simulated time.
  ///   - commandName: The name of the command.
  /// - Returns: The next date and time the command will be executed or `nil` if the input is invalid.
  func nextDateForCommandWithSpecificTime(expectedTime: Time, simulatedTime: Time, commandName: String) -> String? {
    guard let expectedDate = expectedTime.date, let simulatedDate = simulatedTime.date else {
      return nil
    }

    if expectedDate >= simulatedDate {
      return String(format: StringFormat.today, expectedTime.hour, expectedTime.minute, commandName)
    } else {
      return String(format: StringFormat.tomorrow, expectedTime.hour, expectedTime.minute, commandName)
    }
  }

  /// Parses the simplified cron syntax with any execution hour and minute
  /// - Parameters:
  ///   - simulatedTime: The simulated time.
  ///   - commandName: The name of the command.
  /// - Returns: The next date and time the command will be executed or `nil` if the input is invalid.
  func nextDateForCommandWithAnyTime(simulatedTime: Time, commandName: String) -> String? {
    return String(
      format: StringFormat.today,
      simulatedTime.hour,
      simulatedTime.minute, commandName)
  }

  /// Parses the simplified cron syntax with a specific execution hour and any minute
  /// - Parameters:
  ///   - hour: The specific hour the command should run at.
  ///   - simulatedTime: The simulated time.
  ///   - commandName: The name of the command.
  /// - Returns: The next date and time the command will be executed or `nil` if the input is invalid.
  func nextDateForCommandWithSpecificHour(hour: Int, simulatedTime: Time, commandName: String) -> String? {
    var components = DateComponents()
    components.hour = hour
    guard
      let simulatedDate = simulatedTime.date,
      let dateToCompareWith = Calendar.current.date(from: components) else {
      return nil
    }

    if simulatedDate <= dateToCompareWith {
      return String(format: StringFormat.today, hour, 0, commandName)
    } else {
      return String(format: StringFormat.tomorrow, hour, 0, commandName)
    }
  }

  /// Parses the simplified cron syntax with a specific execution minute and any hour.
  /// - Parameters:
  ///   - minute: The specific minute the command should run at.
  ///   - simulatedTime: The simulated time.
  ///   - commandName: The name of the command.
  /// - Returns: The next date and time the command will be executed or `nil` if the input is invalid.
  func nextDateForCommandWithSpecificMinute(minute: Int, simulatedTime: Time, commandName: String) -> String? {
    var components = DateComponents()
    components.hour = simulatedTime.hour
    components.minute = minute

    guard
      let simulatedDate = simulatedTime.date,
      let dateToCompareWith = Calendar.current.date(from: components) else {
      return nil
    }

    if simulatedDate <= dateToCompareWith {
      return String(format: StringFormat.today, simulatedTime.hour, minute, commandName)
    } else {
      guard let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: simulatedDate) else {
        return nil
      }

      let nextHour = Calendar.current.component(.hour, from: nextDate)
      if Calendar.current.isDate(nextDate, equalTo: simulatedDate, toGranularity: .day) {
        return String(format: StringFormat.today, nextHour, minute, commandName)
      } else {
        return String(format: StringFormat.tomorrow, nextHour, minute, commandName)
      }
    }
  }

  enum StringFormat {
    public static let today = "%d:%d today - %@"
    public static let tomorrow = "%d:%d tomorrow - %@"
  }
}
