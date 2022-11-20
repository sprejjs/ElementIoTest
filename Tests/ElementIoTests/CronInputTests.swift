//
//  CronInputTests.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import XCTest
@testable import ElementIo

final class CronInputTests: XCTestCase {}

// MARK: - init tests
extension CronInputTests {
  func test_init_validInput() {
    // GIVEN valid input
    let input: [String] = [
      "30 1 /bin/run_me_daily",
      "45 * /bin/run_me_hourly",
      "* * /bin/run_me_every_minute",
      "* 19 /bin/run_me_sixty_times",
    ]

    for input in input {
      // WHEN CronInput is initalised
      let result = CronInputImpl(input: input)

      // THEN it is not `nil`
      XCTAssertNotNil(result)
    }
  }

  func test_init_invalidInput() {
    // GIVEN invalid input
    let input: [String] = [
      "30 1 /bin/run_me_daily somethingElse", // Too many elements
      "45 *", //Missing command
      "* /bin/run_me_every_minute", // Too few elements
      "* 26 /bin/run_me_sixty_times", // Invalid hour
    ]

    for input in input {
      // WHEN object is instanciated
      let result = CronInputImpl(input: input)

      // THEN the result is `nil`
      XCTAssertNil(result)
    }
  }
}

// MARK: - timeElementFromString tests
extension CronInputTests {
  func test_timeElementFromString_validInput() {
    // GIVEN valid input
    let input: [TestData.CronTimeUnitFromString] = [
      .init(
        string: "0",
        elementType: .hour,
        expectedOutput: .number(0)),
      .init(
        string: "15",
        elementType: .minute,
        expectedOutput: .number(15)),
      .init(
        string: "*",
        elementType: .hour,
        expectedOutput: .any),
      .init(
        string: "*",
        elementType: .minute,
        expectedOutput: .any),
    ]

    for input in input {
      // WHEN the input is parsed
      let result = CronInputImpl.timeElementFromString(
        input.string,
        elementType: input.elementType)

      // THEN the result is matching the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }

  func test_parseTimeElementFromString_invalidInput() {
    // GIVEN invalid input
    let input: [TestData.CronTimeUnitFromString] = [
      .init(
        string: "Zero",
        elementType: .hour,
        expectedOutput: nil),
      .init(
        string: nil,
        elementType: .hour,
        expectedOutput: nil),
      .init(
        string: "24",
        elementType: .hour,
        expectedOutput: nil),
      .init(
        string: "60",
        elementType: .minute,
        expectedOutput: nil),
    ]

    for input in input {
      // WHEN the input is parsed
      let result = CronInputImpl.timeElementFromString(
        input.string, elementType: input.elementType)

      // THEN the result is `nil`
      XCTAssertEqual(result, input.expectedOutput)
    }
  }
}

private struct TestData {
  struct Init {
    let input: String
    let expectedOutput: CronInput?
  }
  struct CronTimeUnitFromString {
    let string: String?
    let elementType: TimeElementParser.ElementType
    let expectedOutput: CronTimeUnit?
  }
}
