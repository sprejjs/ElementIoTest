import Foundation

@main
public struct ElementIo {

  /// The CLI function that accepts the simplified Cron syntax in standard input and the simulated time as an argument and prints the next execution day & time for each command.
  /// The function exits silently if input is invalid.
  public static func main() {
    let parser: CronJobNextDateCommandParser
      = CronJobNextDateCommandParserImpl()

    let input = FileHandle.standardInput

    guard
      let simulatedTime = parseSimulatedTimeFromArguments(CommandLine.arguments),
      let commands = String(bytes: input.availableData, encoding: .utf8)
    else {
      return
    }

    for command in commands.components(separatedBy: .newlines) {
      if let output = parser.nextDateForCommand(command, simulatedTime: simulatedTime) {
        print(output)
      }
    }
  }

  /// Converts supplied arguments to a Time object. Only two arguments are considered valid with the first argument being the path of the fuction and the second arguments being the simulated time in the format `x:y`. `x` is the simulated hour and `y` is the simulated minute.
  ///
  /// The function return nil if input is invalid.
  /// - Parameter arguments: List of arguments supplied to the application executable.
  /// - Returns: either constructed `Time` object or `nil` in case of invalid input.
  static func parseSimulatedTimeFromArguments(_ arguments: [String]) -> Time? {
    guard
      arguments.count == 2,
      let simulatedTime = TimeImpl(input: arguments.last) else {
      return nil
    }

    return simulatedTime
  }
}
