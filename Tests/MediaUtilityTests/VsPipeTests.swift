import XCTest
@testable import MediaTools

final class VsPipeTests: XCTestCase {
  func testExamples() {
    let script = "script.vpy"
    let outfile = "output.raw"
    var vspipe = VsPipe(script: script, output: .info)
    XCTAssertEqual(vspipe.arguments, ["-i", script])

    vspipe.output = .file(.stdout)
    XCTAssertEqual(vspipe.arguments, [script, "-"])

    vspipe.output = .file(.none)
    XCTAssertEqual(vspipe.arguments, [script, "."])

    vspipe.start = 5
    vspipe.end = 100
    vspipe.output = .file(.path(outfile))
    XCTAssertEqual(vspipe.arguments, ["-s", "5", "-e", "100", script, outfile])
  }

  func testParseInfo() throws {
    let outputString = """
    Width: 1920
    Height: 1080
    Frames: 3587
    FPS: 30000/1001 (29.970 fps)
    Format Name: YUV420P8
    Color Family: YUV
    Alpha: No
    Sample Type: Integer
    Bits: 8
    SubSampling W: 1
    SubSampling H: 1
    """

    let info = try VsPipe.Info.parse(outputString)
    XCTAssertEqual(info.width, 1920)
    XCTAssertEqual(info.height, 1080)
    XCTAssertEqual(info.frames, 3587)
    XCTAssertEqual(info.fps.0, 30000)
    XCTAssertEqual(info.fps.1, 1001)
    XCTAssertEqual(info.formatName, "YUV420P8")
    XCTAssertEqual(info.bits, 8)
  }
}
