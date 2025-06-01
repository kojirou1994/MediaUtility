import ExecutableDescription
import Precondition
import KwiftExtension
import Foundation

public struct VsPipe: Executable, IncrementalArguments {

  public static var executableName: String { "vspipe" }

  public init(script: String, output: Output, start: Int? = nil, end: Int? = nil, container: OutputContainer? = nil) {
    self.script = script
    self.output = output
    self.start = start
    self.end = end
    self.container = container
  }

  public var script: String
  public var output: Output

  // MARK: common options
//  public var keyValues: [String]
  
  /// Set output frame/sample range start
  public var start: Int?
  /// Set output frame/sample range end (inclusive)
  public var end: Int?
  /// Select output index
  public var outputIndex: Int?
  /// Set number of concurrent frame requests
  public var requests: Int?
  /// Add headers for the specified format to the output
  public var container: OutputContainer?
  /// Write timecodes v2 file
  public var timecodes: String?
  /// Write properties of output frames to JSON file
  public var json: String?
  /// Print progress to stderr
  public var progress: Bool = false
  /// Print time spent in individual filters after processing
  public var filterTime: Bool = false

  public enum Output {
    /// Print output node info and exit
    case info
    /// Print output node filter graph in dot format and exit
    case graph(_ option: GraphOption)
    case file(_ option: FileOutput)

    public enum GraphOption: String {
      case simple
      case full
    }

    public struct FileOutput: ExpressibleByStringLiteral {
      internal let rawValue: String

      public static func path(_ value: String) -> Self {
        assert("value" != "-", "use stdout")
        assert("value" != "--" && "value" != ".", "use none")
        return .init(rawValue: value)
      }

      /// Write to stdout
      public static var stdout: Self {
        .init(rawValue: "-")
      }

      /// No output
      public static var none: Self {
        .init(rawValue: ".")
      }

      public init(stringLiteral value: String) {
        self = .path(value)
      }

      init(rawValue: String) {
        self.rawValue = rawValue
      }
    }
  }

  public enum OutputContainer: String {
    case y4m, wav, w64
  }

  public func writeArguments(to builder: inout ArgumentsBuilder) {
    builder.add(flag: "-s", value: start)
    builder.add(flag: "-e", value: end)
    builder.add(flag: "-o", value: outputIndex)
    builder.add(flag: "-r", value: requests)
    builder.add(flag: "-c", value: container?.rawValue)
    builder.add(flag: "-t", value: timecodes)
    builder.add(flag: "-j", value: json)
    builder.add(flag: "-p", when: progress)
    builder.add(flag: "--filter-time", when: filterTime)
    switch output {
    case .info:
      builder.add(flag: "-i")
      builder.add(flag: script)
    case .graph(let option):
      builder.add(flag: "-g", value: option.rawValue)
      builder.add(flag: script)
    case .file(let option):
      builder.add(flag: script)
      builder.add(flag: option.rawValue)
    }
  }
}

/*
 vspipe info
 src:
 https://github.com/vapoursynth/vapoursynth/blob/7d52908cd75147e1a611746405d84baf7cf671f8/src/vspipe/vspipe.cpp#L1100

 variable props not supported
 */
extension VsPipe {

  public struct Info {
    public let width: Int
    public let height: Int
    /// format: 30000/1001 (29.970 fps)
    public let frames: Int
    public let fps: FPS
    public let formatName: String
    public let bits: Int

    /// num and den
    public typealias FPS = (Int, Int)

    public static func parse(fps: some StringProtocol) throws -> FPS {
      let main = fps.prefix(while: { $0 != " " })
      let parts = main.split(separator: "/")
      try preconditionOrThrow(parts.count == 2)
      return try (Int(parts[0]).unwrap(), Int(parts[1]).unwrap())
    }

    public static func parse(_ string: String) throws -> Self {
      var props = [Substring: String]()
      for line in string.lazySplit(separator: "\n") {
        let parts = line.split(separator: ":", maxSplits: 1)
        assert(parts.count == 2, "invalid vspipe info line: \(line)")
        props[parts[0]] = parts[1].trimmingCharacters(in: .whitespaces)
      }

      return try .init(
        width: Int(props["Width"].unwrap()).unwrap(),
        height: Int(props["Height"].unwrap()).unwrap(),
        frames: Int(props["Frames"].unwrap()).unwrap(),
        fps: parse(fps: props["FPS"].unwrap()),
        formatName: String(props["Format Name"].unwrap()),
        bits: Int(props["Bits"].unwrap()).unwrap()
      )
    }
  }
}
