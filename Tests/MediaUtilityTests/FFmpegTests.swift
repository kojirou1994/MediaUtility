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

  func testMapMetadataSpecifier() {
    XCTAssertEqual(FFmpeg.MetadataSpecifier.global.argument, ":g")
    XCTAssertEqual(FFmpeg.MetadataSpecifier.stream(.streamIndex(0)).argument, ":s:0")
    XCTAssertEqual(FFmpeg.MetadataSpecifier.stream(.streamType(.audio)).argument, ":s:a")

    let example1 = FFmpeg(ios: [.input(url: "in.ogg"), .output(url: "out.mp3", options: [.mapMetadata(outputSpec: nil, inputFileIndex: 0, inputSpec: .stream(.streamIndex(0)))])])

    XCTAssertEqual(example1.arguments.joined(separator: " "), "-i in.ogg -map_metadata 0:s:0 out.mp3")

    let example2 = FFmpeg(ios: [.input(url: "in.mkv"), .output(url: "out.mkv", options: [.mapMetadata(outputSpec: .stream(.streamType(.audio)), inputFileIndex: 0, inputSpec: .global)])])

    XCTAssertEqual(example2.arguments.joined(separator: " "), "-i in.mkv -map_metadata:s:a 0:g out.mkv")
  }
}
