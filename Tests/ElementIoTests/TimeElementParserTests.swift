//
//  TimeElementParserTests.swift
//  
//
//  Created by Allan Spreys on 20/11/2022.
//

import XCTest
@testable import ElementIo

final class TimeElementParserTests: XCTestCase {}

// MARK: - timeElementFromInt tests
extension TimeElementParserTests {
  func test_timeElementFromInt_validInput() {
    // GIVEN valid input
    let input: [TestData.FromInt] = [
      .init(
        input: 0,
        elementType: .hour,
        expectedOutput: 0),
      .init(
        input: 23,
        elementType: .hour,
        expectedOutput: 23),
      .init(
        input: 0,
        elementType: .minute,
        expectedOutput: 0),
      .init(
        input: 59,
        elementType: .minute,
        expectedOutput: 59),
    ]

    for input in input {
      // WHEN the element is parsed
      let result = TimeElementParser.timeElementFromInt(
        input.input, elementType: input.elementType)

      // THEN the parsed element matches the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }

  func test_timeElementFromInt_invalidInput() {
    // GIVEN invalid input
    let input: [TestData.FromInt] = [
      .init(
        input: nil, // The input is nil
        elementType: .hour,
        expectedOutput: nil),
      .init(
        input: nil, // The input is nil
        elementType: .minute,
        expectedOutput: nil),
      .init(
        input: -1, // The minute is negative
        elementType: .minute,
        expectedOutput: nil),
      .init(
        input: 60, // The minute is too large
        elementType: .minute,
        expectedOutput: nil),
      .init(
        input: -1, // The hour is negative
        elementType: .hour,
        expectedOutput: nil),
      .init(
        input: 25, // The hour is too large
        elementType: .hour,
        expectedOutput: nil),
    ]

    for input in input {
      // WHEN the element is parsed
      let result = TimeElementParser.timeElementFromInt(
        input.input, elementType: input.elementType)

      // THEN the parsed element is `nil`
      XCTAssertNil(result)
    }
  }
}

// MARK: - timeElementFromString tests
extension TimeElementParserTests {
  func test_timeElementFromString_validInput() {
    // GIVEN valid input
    let input: [TestData.FromString] = [
      .init(
        input: "0",
        elementType: .hour,
        expectedOutput: 0),
      .init(
        input: "23",
        elementType: .hour,
        expectedOutput: 23),
      .init(
        input: "0",
        elementType: .minute,
        expectedOutput: 0),
      .init(
        input: "59",
        elementType: .minute,
        expectedOutput: 59),
    ]

    for input in input {
      // WHEN the element is parsed
      let result = TimeElementParser.timeElementFromString(
        input.input, elementType: input.elementType)

      // THEN the parsed element matches the expectation
      XCTAssertEqual(result, input.expectedOutput)
    }
  }

  func test_timeElementFromString_invalidInput() {
    // GIVEN invalid input
    let input: [TestData.FromString] = [
      .init(
        input: nil, // The input is nil
        elementType: .hour,
        expectedOutput: nil),
      .init(
        input: nil, // The input is nil
        elementType: .minute,
        expectedOutput: nil),
      .init(
        input: "-1", // The minute is negative
        elementType: .minute,
        expectedOutput: nil),
      .init(
        input: "60", // The minute is too large
        elementType: .minute,
        expectedOutput: nil),
      .init(
        input: "-1", // The hour is negative
        elementType: .hour,
        expectedOutput: nil),
      .init(
        input: "25", // The hour is too large
        elementType: .hour,
        expectedOutput: nil),
      .init(
        input: "YY", // The input contains invalid characters
        elementType: .hour,
        expectedOutput: nil),
    ]

    for input in input {
      // WHEN the element is parsed
      let result = TimeElementParser.timeElementFromString(
        input.input, elementType: input.elementType)

      // THEN the parsed element is `nil`
      XCTAssertNil(result)
    }
  }
}

private struct TestData {
  struct FromInt {
    let input: Int?
    let elementType: TimeElementParser.ElementType
    let expectedOutput: Int?
  }

  struct FromString {
    let input: String?
    let elementType: TimeElementParser.ElementType
    let expectedOutput: Int?
  }
}
