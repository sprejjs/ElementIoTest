//
//  CronJobNextDateCommandParserTests.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import XCTest
@testable import ElementIo

final class CronJobNextDateCommandParserTests: XCTestCase {

  var subject: CronJobNextDateCommandParserImpl!

  override func setUp() {
    super.setUp()

    subject = CronJobNextDateCommandParserImpl()
  }
}

// MARK: - nextDateForCommand tests

extension CronJobNextDateCommandParserTests {
  func test_mainFunction() {
    // GIVEN arbitrary input
    let input: [TestData.WithArbitraryInput] = [
      .init(
        input: "30 1 /bin/run_me_daily",
        simulatedTime: .init(input: "16:10")!,
        expectedOutput: "1:30 tomorrow - /bin/run_me_daily"),
      .init(
        input: "45 * /bin/run_me_hourly",
        simulatedTime: .init(input: "16:10")!,
        expectedOutput: "16:45 today - /bin/run_me_hourly"),
      .init(
        input: "* * /bin/run_me_every_minute",
        simulatedTime: .init(input: "16:10")!,
        expectedOutput: "16:10 today - /bin/run_me_every_minute"),
      .init(
        input: "* 19 /bin/run_me_sixty_times",
        simulatedTime: .init(input: "16:10")!,
        expectedOutput: "19:0 today - /bin/run_me_sixty_times"),
    ]

    for input in input {
      let result = subject.nextDateForCommand(input.input, simulatedTime: input.simulatedTime)
      XCTAssertEqual(result, input.expectedOutput)
    }
  }

  func test_invalidInput() {
    // GIVEN the provided input is invalid
    let input: [String] = [
      "45 /bin/run_me_hourly", // Missing hour component
      "45 1", // Missing command
      "61 1 /bin/run_me_hourly", // Minute too large
      "-59 25 /bin/run_me_hourly", // Negative minute
      "59 -1 /bin/run_me_hourly", // Negative hour
      "59 25 /bin/run_me_hourly", // Hour too large
    ]
    
    for input in input {
      // WHEN the input is parsed
      let result = subject.nextDateForCommand(input, simulatedTime: TimeImpl(input: "16:10")!)
      
      // THEN the result is `nil`
      XCTAssertNil(result)
    }
  }
}

// MARK: - nextDateForCommandWithAnyTime tests
extension CronJobNextDateCommandParserTests {
  func test_withAnyTime() {
    // GIVEN the input specified any hour and any minute
    let input: [TestData.WithAnyTime] = [
      .init(simulatedTime: .init(input: "16:10")!, commandName: "/bin/command_name", expectedOutput: "16:10 today - /bin/command_name"),
      .init(simulatedTime: .init(input: "00:00")!, commandName: "/bin/command_name", expectedOutput: "0:0 today - /bin/command_name"),
      .init(simulatedTime: .init(input: "23:59")!, commandName: "/bin/command_name", expectedOutput: "23:59 today - /bin/command_name"),
    ]

    for input in input {
      // WHEN the input is parsed
      let result = subject.nextDateForCommandWithAnyTime(simulatedTime: input.simulatedTime, commandName: input.commandName)

      // THEN the result is matching the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }
}

// MARK: - nextDateForCommandWithSpecificTime tests
extension CronJobNextDateCommandParserTests {
  func test_withSpecificTime() {
    // GIVEN the input specifies both the hour and the minute
    let input: [TestData.WithSpecificTime] = [
      .init(
        expectedTime: .init(input: "16:10")!,
        simulatedTime: .init(input: "16:10")!,
        commandName: "/bin/command_name",
        expectedOutput: "16:10 today - /bin/command_name"
      ),
      .init(
        expectedTime: .init(input: "17:10")!,
        simulatedTime: .init(input: "16:10")!,
        commandName: "/bin/command_name",
        expectedOutput: "17:10 today - /bin/command_name"
      ),
      .init(
        expectedTime: .init(input: "15:10")!,
        simulatedTime: .init(input: "16:10")!,
        commandName: "/bin/command_name",
        expectedOutput: "15:10 tomorrow - /bin/command_name"
      ),
      .init(
        expectedTime: .init(input: "15:10")!,
        simulatedTime: .init(input: "15:09")!,
        commandName: "/bin/command_name",
        expectedOutput: "15:10 today - /bin/command_name"
      ),
      .init(
        expectedTime: .init(input: "15:10")!,
        simulatedTime: .init(input: "15:11")!,
        commandName: "/bin/command_name",
        expectedOutput: "15:10 tomorrow - /bin/command_name"
      ),
    ]

    for input in input {
      // WHEN the input is parsed
      let result = subject.nextDateForCommandWithSpecificTime(
        expectedTime: input.expectedTime,
        simulatedTime: input.simulatedTime,
        commandName: input.commandName)

      // THEN the result is matching the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }
}

// MARK: - nextDateForCommandWithSpecificHour tests
extension CronJobNextDateCommandParserTests {
  func test_withSpecificHour() {
    // GIVEN the input specified the hour and any minute
    let input: [TestData.WithSpecificHour] = [
      .init(
        expectedHour: 19,
        simulatedTime: .init(input: "18:10")!,
        commandName: "/bin/command_name",
        expectedOutput: "19:0 today - /bin/command_name"),
      .init(
        expectedHour: 19,
        simulatedTime: .init(input: "19:00")!,
        commandName: "/bin/command_name",
        expectedOutput: "19:0 today - /bin/command_name"),
      .init(
        expectedHour: 19,
        simulatedTime: .init(input: "19:10")!,
        commandName: "/bin/command_name",
        expectedOutput: "19:0 tomorrow - /bin/command_name"),
      .init(
        expectedHour: 0,
        simulatedTime: .init(input: "19:0")!,
        commandName: "/bin/command_name",
        expectedOutput: "0:0 tomorrow - /bin/command_name"),
    ]

    for input in input {
      // WHEN the input is parsed
      let result = subject.nextDateForCommandWithSpecificHour(
        hour: input.expectedHour,
        simulatedTime: input.simulatedTime,
        commandName: input.commandName)

      // THEN the result is matching the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }
}

// MARK: - nextDateForCommandWithSpecificMinute tests
extension CronJobNextDateCommandParserTests {
  func test_withSpecificMinute() {
    // GIVEN the provided input specifies the minute and any hour
    let input: [TestData.WithSpecificMinute] = [
      .init(
        expectedMinute: 15,
        simulatedTime: .init(input: "18:10")!,
        commandName: "/bin/command_name",
        expectedOutput: "18:15 today - /bin/command_name"),
      .init(
        expectedMinute: 15,
        simulatedTime: .init(input: "18:15")!,
        commandName: "/bin/command_name",
        expectedOutput: "18:15 today - /bin/command_name"),
      .init(
        expectedMinute: 15,
        simulatedTime: .init(input: "18:20")!,
        commandName: "/bin/command_name",
        expectedOutput: "19:15 today - /bin/command_name"),
      .init(
        expectedMinute: 15,
        simulatedTime: .init(input: "23:20")!,
        commandName: "/bin/command_name",
        expectedOutput: "0:15 tomorrow - /bin/command_name"),
    ]

    for input in input {
      // WHEN the input is parsed
      let result = subject.nextDateForCommandWithSpecificMinute(
        minute: input.expectedMinute,
        simulatedTime: input.simulatedTime,
        commandName: input.commandName)

      // THEN it matches the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }
}

private struct TestData {
  struct WithSpecificTime {
    let expectedTime: TimeImpl
    let simulatedTime: TimeImpl
    let commandName: String
    let expectedOutput: String
  }

  struct WithSpecificHour {
    let expectedHour: Int
    let simulatedTime: TimeImpl
    let commandName: String
    let expectedOutput: String
  }

  struct WithSpecificMinute {
    let expectedMinute: Int
    let simulatedTime: TimeImpl
    let commandName: String
    let expectedOutput: String
  }

  struct WithAnyTime {
    let simulatedTime: TimeImpl
    let commandName: String
    let expectedOutput: String
  }

  struct WithArbitraryInput {
    let input: String
    let simulatedTime: TimeImpl
    let expectedOutput: String
  }
}
