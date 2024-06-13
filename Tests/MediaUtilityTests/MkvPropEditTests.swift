import XCTest
import MediaTools

final class MkvPropEditTests: XCTestCase {

  func testArguments() {
    var edit = MkvPropEdit(filepath: "movie.mkv")
    edit.actions.append(.init(selector: .segmentInformation, modifications: [.set(name: "title", value: "The movie")]))
    edit.actions.append(.init(selector: .track(.index(1, type: .audio)), modifications: [.set(name: "language", value: "fre")]))
    edit.actions.append(.init(selector: .track(.index(2, type: .audio)), modifications: [.set(name: "language", value: "ita")]))

    print(edit.arguments)

    edit.actions = [

    ]
    edit.chapter = ""

    print(edit.arguments)
  }
}
