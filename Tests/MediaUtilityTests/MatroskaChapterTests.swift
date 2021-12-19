import XCTest
import MediaTools
import MediaUtility

final class MatroskaChapterTests: XCTestCase {
  func testFillUIDs() {
    var chapter = MatroskaChapter(entries: [.init(chapters: [.init(startTime: Timestamp.zero), .init(startTime: Timestamp.hour)])])
    print(chapter)
    chapter.fillUIDs()
    print(chapter)

    var uids = Set<UInt>()
    chapter.entries.forEach { entry in
      XCTAssertTrue(uids.insert(entry.uid).inserted)
      entry.chapters.forEach { chapter in
        XCTAssertTrue(uids.insert(chapter.uid).inserted)
      }
    }
  }
}
