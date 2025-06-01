import ExecutableDescription

public struct MediaInfo: Executable, IncrementalArguments {

  public static var executableName: String { "mediainfo" }

  public init(full: Bool = false, output: Output? = nil, files: [String]) {
    self.full = full
    self.output = output
    self.files = files
  }

  /// Full information Display (all internal tags)
  public var full: Bool
  public var output: Output?
  public var files: [String]

  public enum Output: String {
    case html = "HTML"
    case xml = "XML"
    /// XML tags using the older MediaInfo schema
    case oldXML = "OLDXML"
    case json = "JSON"
    case EBUCore
    case EBUCore_JSON
    case PBCore
    case PBCore2
  }

  public func writeArguments(to builder: inout ArgumentsBuilder) {
    builder.add(flag: "-f", when: full)
    if let output {
      builder.add(flag: "--Output=\(output.rawValue)")
    }
    builder.append(arguments: files)
  }

}
