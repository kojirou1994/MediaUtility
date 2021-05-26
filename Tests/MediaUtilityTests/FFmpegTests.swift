import XCTest
@testable import MediaTools

final class FFmpegTests: XCTestCase {

  func testSize() {
    print(MemoryLayout<FFmpeg>.size)
    print(MemoryLayout<FFmpeg>.alignment)
    print(MemoryLayout<FFmpeg>.stride)
    print(MemoryLayout<FFmpeg>.self)
    print(MemoryLayout.offset(of: \FFmpeg.ios)!)
  }

  func testEmptyArg() {
    let empty = FFmpeg()
    XCTAssertEqual(empty.arguments, [])
  }

  func testStreamSpecifierArgument() {
    XCTAssertEqual(FFmpeg.StreamSpecifier.streamType(.audio, additional: .streamIndex(1)).argument, ":a:1")
    XCTAssertEqual(FFmpeg.StreamSpecifier.streamType(.audio, additional: nil).argument, ":a")
  }
}
