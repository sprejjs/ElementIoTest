import XCTest
@testable import ElementIo

final class ElementIoTests: XCTestCase {}

// MARK: - parseSimulatedTimeFromArguments tests
extension ElementIoTests {
  func test_parseSimulatedTimeFromArguments_validInput() {
    // GIVEN input is valid
    let input: [[String]] = [
      ["/path/", "16:10"],
      ["/path/", "16:0"],
      ["/path/", "23:59"],
    ]

    for input in input {
      // WHEN the simulated time is parsed
      let result = ElementIo.parseSimulatedTimeFromArguments(input)

      // THEN the result is not nil
      XCTAssertNotNil(result)
    }
  }

  func test_parseSimulatedTimeFromArguments_invalidInput() {
    // GIVEN input is invalid
    let input: [[String]] = [
      ["/path/", "16:10", "another_argument"], // Too many arguments
      ["16:10"], // Too few arguments
      ["/path/", "24:10"], // Invalid simulated time
    ]

    for input in input {
      // WHEN the simulated time is parsed
      let result = ElementIo.parseSimulatedTimeFromArguments(input)

      // THEN the result is nil
      XCTAssertNil(result)
    }
  }
}
