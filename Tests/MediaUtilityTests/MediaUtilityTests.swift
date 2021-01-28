import XCTest
@testable import MediaUtility
@testable import MediaTools
import XMLParsing
import ExecutableLauncher

final class MediaUtilityTests: XCTestCase {

  override func setUp() {
    super.setUp()
    ExecutablePath.set(path: "/usr/local/bin")
  }

  func testDecodeTimestamp() {
    func _testTimestamp(_ allZero: String, strict: Bool) {
      for zeroIndex in allZero.indexes(of: "0") {
        let str = String(allZero[..<zeroIndex]) + "1" + allZero[allZero.index(after: zeroIndex)...]
        let timestamp = Timestamp(string: str, strictMode: strict)
        XCTAssertNotNil(timestamp)
        if strict {
          XCTAssertEqual(timestamp!.toString(displayNanoSecond: !strict), str)
        } else {
          let generatedString = timestamp!.toString(displayNanoSecond: !strict)
          XCTAssertTrue(generatedString.hasPrefix(str))
          XCTAssertTrue(generatedString.dropFirst(str.count).allSatisfy({$0 == "0"}))
        }
      }
    }

    var allZero = "00:00:00.000"
    _testTimestamp(allZero, strict: true)

    for _ in 0...6 {
      _testTimestamp(allZero, strict: false)
      allZero += "0"
    }
    measure {
      _ = Timestamp(string: "00:00:00.000")
    }
  }
}
