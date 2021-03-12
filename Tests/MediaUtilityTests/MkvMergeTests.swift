import XCTest
@testable import MediaTools

final class MkvMergeTests: XCTestCase {

  func testGlobalOptionArgument() {

    let raw = "Chapter <NUM:2>"
    var chaptersNameTemplate: MkvMerge.GlobalOption.ChaptersNameTemplate = .raw(raw)
    XCTAssertEqual(chaptersNameTemplate.argument, raw)

    chaptersNameTemplate = .components(["Chapter ", .chapterNumber(padding: 2)])
    XCTAssertEqual(chaptersNameTemplate.argument, raw)
  }
}
