import XCTest
@testable import MediaUtility
@testable import MediaTools

final class MediaUtilityTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ExecutablePath.set("/usr/local/bin")
    }

    func testExample() {
        print(try! FlacMD5.calculate(inputs: """
/Volumes/SAMSUNG_TF_64G/FoundationTest/MD5/pure.flac
/Volumes/SAMSUNG_TF_64G/FoundationTest/MD5/s.flac
/Volumes/SAMSUNG_TF_64G/FoundationTest/MD5/sample.flac
"""
            .components(separatedBy: .newlines)))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
