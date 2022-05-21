import Foundation
import MediaUtility
import ExecutableDescription
import ExecutableLauncher
import KwiftExtension

@available(*, deprecated, renamed: "MkvMergeIdentification")
public typealias MkvmergeIdentification = MkvMergeIdentification

extension MkvMergeIdentification {

  @available(macOS 10.15, *)
  public init(url: URL) throws {
    try self.init(filePath: url.path)
  }

  @available(macOS 10.15, *)
  public init(filePath: String) throws {
    let mkvmerge = try AnyExecutable(
      executableName: "mkvmerge", arguments: ["-J", filePath]
    ).launch(use: TSCExecutableLauncher(outputRedirection: .collect)).output.get()
    self = try JSONDecoder().kwiftDecode(from: mkvmerge)
  }

}

extension MkvMergeIdentification.Track {
  public var trackType: MediaTrackType {
    .init(rawValue: type)!
  }
}