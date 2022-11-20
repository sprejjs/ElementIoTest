//
//  TimeTests.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import XCTest
@testable import ElementIo

final class TimeTests: XCTestCase {}

extension TimeTests {}

// MARK: - init with hour and minute tests
extension TimeTests {
  func test_initHourMinute_validInput() {
    // GIVEN valid input
    let input: [TestData] = [
      .init(hour: 14, minute: 10),
      .init(hour: 14, minute: 55),
      .init(hour: 0, minute: 0),
    ]

    for input in input {
      // WHEN the the time object is initialised
      let result = TimeImpl(hour: input.hour, minute: input.minute)

      // THEN the object is not nil
      XCTAssertNotNil(result)
    }
  }

  func test_initHourMinute_invalidInput() {
    // GIVEN invalid input
    let input: [TestData] = [
      .init(hour: nil, minute: nil), // Both objects are nil
      .init(hour: nil, minute: 15), // Hour is nil
      .init(hour: 15, minute: nil), // Minute is nil
      .init(hour: 26, minute: 0), // Invalid hour
      .init(hour: 15, minute: -1), // Invalid minute
    ]

    for input in input {
      // WHEN the time object is initialised.
      let result = TimeImpl(hour: input.hour, minute: input.minute)

      // THEN the object is nil
      XCTAssertNil(result)
    }
  }
}

// MARK: init with string tests
extension TimeTests {
  func test_init_validInput() {
    // GIVEN valid input
    let input: [String] = [
      "16:10",
      "0:0",
      "23:59",
    ]

    for input in input {
      // WHEN the object is initialised
      let result = TimeImpl(input: input)

      // THEN the object is not nil
      XCTAssertNotNil(result)
    }
  }

  func test_init_invalidInput() {
    // GIVEN invalid input
    let input: [String] = [
      "16 10", // Invalid separator
      "16:10 x", // Extra characters
      "25:10", // Invalid hour
      "16:60", // Invalid minute
    ]

    for input in input {
      // WHEN the object is initialised
      let result = TimeImpl(input: input)

      // THEN the object is nil
      XCTAssertNil(result)
    }
  }
}

private struct TestData {
  let hour: Int?
  let minute: Int?
}
