import ExecutableDescription

public struct FFmpegCopyMuxer: Executable {

  public static let executableName = "ffmpeg"

  public let input: String

  public let output: String

  public let mode: CopyMode

  public struct CopyMode: OptionSet {

    public var rawValue: UInt8

    public init(rawValue: UInt8) {
      self.rawValue = rawValue
    }

    public static var video: Self      { .init(rawValue: 1 << 0) }
    public static var audio: Self      { .init(rawValue: 1 << 1) }
    public static var subtitle: Self   { .init(rawValue: 1 << 2) }
    public static var copyAll: Self    { [.video, .audio, .subtitle] }

    @available(*, deprecated, renamed: "video")
    public static var videoOnly: Self { video }
    @available(*, deprecated, renamed: "audio")
    public static var audioOnly: Self { audio }
  }

  public init(input: String, output: String) {
    self.input = input
    self.output = output
    self.mode = .copyAll
  }

  public init(input: String, output: String, mode: CopyMode) {
    self.input = input
    self.output = output
    self.mode = mode
  }

  public var arguments: [String] {
    var arguments = ["-v", "quiet", "-nostdin", "-y", "-i", input, "-c", "copy"]
    if !mode.contains(.video) {
      arguments.append("-vn")
    }
    if !mode.contains(.audio) {
      arguments.append("-an")
    }
    if !mode.contains(.subtitle) {
      arguments.append("-sn")
    }
    arguments.append(output)
    return arguments
  }

}
