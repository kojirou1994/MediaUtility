import Foundation
import KwiftExtension

public struct Chapter {

  public struct ChapterNode {
    public var title: String
    public var timestamp: Timestamp

    public init(title: String, timestamp: Timestamp) {
      self.title = title
      self.timestamp = timestamp
    }
  }

  public var nodes: [ChapterNode]

  /// chapter line like 00:00:00.000 ChapterName
  /// - Parameter fileURL: file location
  public init(fileURL: URL) throws {
    let content = try autoreleasepool {
      try String(contentsOf: fileURL)
    }
    nodes = content.split(separator: "\n").compactMap({
      (line) -> ChapterNode? in
      if line.isEmpty {
        return nil
      } else {
        let parts = line.split(separator: " ")
        //                let time = parts[0].split(separator: ":")
        return .init(
          title: String(parts[1]), timestamp: Timestamp(String(parts[0]))!)
      }
    })
  }

  @inlinable
  public init(nodes: [ChapterNode]) {
    self.nodes = nodes
  }

  public init<C>(timestamps: C) where C: Collection, C.Element == Timestamp {
    self.nodes = timestamps.enumerated().map {
      ChapterNode.init(
        title: String.init(format: "Chapter %02d", $0.offset + 1),
        timestamp: $0.element)
    }
  }

  private func padding(number: Int) -> String {
    if number < 10 {
      return "0\(number)"
    } else {
      return .init(describing: number)
    }
  }

  public enum OgmParseError: Error {
    case empty
    case extraLine(String)
    //        case wrongFormat(String)
  }

  public init(ogmFileURL: URL) throws {
    let str = try autoreleasepool {
      try String(contentsOf: ogmFileURL)
    }
    let lines = str.split(separator: "\n")
    guard lines.count > 0 else {
      throw OgmParseError.empty
    }
    guard lines.count % 2 == 0 || !lines.last!.isEmpty else {
      throw OgmParseError.extraLine(String(lines.last!))
    }
    nodes = .init()
    let nodesCount = lines.count / 2
    nodes.reserveCapacity(nodesCount)
    for index in 0..<nodesCount {
      let timestamp = String(lines[index * 2])
      let title = String(lines[index * 2 + 1])
      nodes.append(
        .init(
          title: String(title[14...]),
          timestamp: Timestamp(String(timestamp[10...]))!))
    }
  }

  public func exportOgm() -> String {
    return nodes.enumerated().map { node -> String in
      let index = padding(number: node.offset + 1)
      return """
        CHAPTER\(index)=\(node.element.timestamp.description)
        CHAPTER\(index)NAME=\(node.element.title)
        """
    }.joined(separator: "\n")
  }

  @inlinable
  public var isEmpty: Bool {
    nodes.count <= 1
  }

}
