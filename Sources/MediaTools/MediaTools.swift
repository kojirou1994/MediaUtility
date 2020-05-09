@_exported import Executable

public enum MediaTools: String {
  case ffmpeg
  case mkvextract
  case mp4Box = "MP4Box"
  case LsmashRemuxer = "remuxer"

  @inlinable
  public func executable(_ arguments: [String]) -> AnyExecutable {
    .init(executableName: rawValue, arguments: arguments)
  }
}
