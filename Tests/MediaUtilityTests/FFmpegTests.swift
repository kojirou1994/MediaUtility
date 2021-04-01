import XCTest
@testable import MediaTools

final class FFmpegTests: XCTestCase {

  func testEmptyArg() {
    let empty = FFmpeg()
    XCTAssertEqual(empty.arguments, [])
  }

  func testStreamSpecifierArgument() {
    XCTAssertEqual(FFmpeg.StreamSpecifier.streamType(.audio, additional: .streamIndex(1)).argument, ":a:1")
    XCTAssertEqual(FFmpeg.StreamSpecifier.streamType(.audio, additional: nil).argument, ":a")
  }
}
