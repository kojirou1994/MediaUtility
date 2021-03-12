import XCTest
@testable import MediaTools

final class ArgumentBuilderTests: XCTestCase {

  func testMultiProtocols() {
    struct A: CustomStringConvertible, CustomArgumentConvertible {
      var description: String { "desc" }
      var argument: String { "arg" }
    }

    var builder = ArgumentBuilder()
    builder.add(flag: "--flag", value: A())
    XCTAssertEqual(builder.arguments, ["--flag", "arg"])
  }
}
