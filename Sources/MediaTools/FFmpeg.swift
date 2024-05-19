import Foundation
import ExecutableDescription

public struct FFmpeg: Executable {
  public init(global: GlobalOptions = .init(), inputs: [Input] = [], outputs: [Output] = []) {
    self.global = global
    self.inputs = inputs
    self.outputs = outputs
  }

  public static var executableName: String { "ffmpeg" }

  public var global: GlobalOptions

  public var inputs: [Input]

  public var outputs: [Output]

  public var arguments: [String] {
    var args = [String]()
    args.append(contentsOf: global.arguments)
    inputs.forEach { input in
      args.append(contentsOf: input.options)
      args.append("-i")
      args.append(input.url)
    }

    outputs.forEach { output in
      args.append(contentsOf: output.options)
      args.append(output.url)
    }
    return args
  }

}

extension Array where Element == String {
  mutating func append(contentsOf options: some Collection<some _FFmpegIOOptions>) {
    options.forEach { option in
      append(option.flag)
      option.value.map { append($0) }
    }
  }
}

// MARK: Global Options
extension FFmpeg {
  public struct GlobalOptions {
    public init(
      logLevel: LogLevel? = nil,
      hideBanner: Bool = false,
      cpuflags: String? = nil, overwrite: Bool? = nil, filterThreadNumber: Int? = nil,
      stats: Bool = true, filterComplexThreadNumber: Int? = nil, filtergraph: String? = nil,
      filterComplextScriptFilename: String? = nil, sdpFile: String? = nil,
      maxErrorRate: Double? = nil, stopAndExitOnError: Bool = false,
      noAutoConversionFilters: Bool = false, statsPeriod: Double? = nil,
      enableStdin: Bool = true,
      progressUrl: String? = nil, debugTimestamp: Bool = false, benchmark: Bool = false,
      benchmarkAll: Bool = false, timelimit: Double? = nil, dumpPacket: Bool = false,
      dumpHex: Bool = false, showQPHistogram: Bool = false, initHardwareDevices: [HardwareDevice] = []
    ) {
      self.logLevel = logLevel
      self.hideBanner = hideBanner
      self.cpuflags = cpuflags
      self.overwrite = overwrite
      self.filterThreadNumber = filterThreadNumber
      self.stats = stats
      self.filterComplexThreadNumber = filterComplexThreadNumber
      self.filtergraph = filtergraph
      self.filterComplextScriptFilename = filterComplextScriptFilename
      self.sdpFile = sdpFile
      self.maxErrorRate = maxErrorRate
      self.stopAndExitOnError = stopAndExitOnError
      self.noAutoConversionFilters = noAutoConversionFilters
      self.statsPeriod = statsPeriod
      self.progressUrl = progressUrl
      self.enableStdin = enableStdin
      self.debugTimestamp = debugTimestamp
      self.benchmark = benchmark
      self.benchmarkAll = benchmarkAll
      self.timelimit = timelimit
      self.dumpPacket = dumpPacket
      self.dumpHex = dumpHex
      self.showQPHistogram = showQPHistogram
      self.initHardwareDevices = initHardwareDevices
    }

    public var logLevel: LogLevel?

    /// Suppress printing banner.
    /// All FFmpeg tools will normally show a copyright notice, build options and library versions. This option can be used to suppress printing this information.
    public var hideBanner: Bool

    public var cpuflags: String?

    /// Overwrite output files without asking.
    public var overwrite: Bool?

    /// Defines how many threads are used to process a filter pipeline. Each pipeline will produce a thread pool with this many threads available for parallel processing. The default is the number of available CPUs.
    public var filterThreadNumber: Int?

    /// Print encoding progress/statistics. It is on by default, to explicitly disable it you need to specify -nostats.
    public var stats: Bool = true

    /// Defines how many threads are used to process a filter_complex graph. Similar to filter_threads but used for -filter_complex graphs only. The default is the number of available CPUs.
    public var filterComplexThreadNumber: Int?

    /// Define a complex filtergraph, i.e. one with arbitrary number of inputs and/or outputs. For simple graphs – those with one input and one output of the same type – see the -filter options. filtergraph is a description of the filtergraph, as described in the “Filtergraph syntax” section of the ffmpeg-filters manual.
    public var filtergraph: String?

    /// This option is similar to -filter_complex, the only difference is that its argument is the name of the file from which a complex filtergraph description is to be read.
    public var filterComplextScriptFilename: String?

    /// Print sdp information for an output stream to file. This allows dumping sdp information when at least one output isn’t an rtp stream. (Requires at least one of the output formats to be rtp).
    public var sdpFile: String?

    //    -abort_on flags (global)
    //    Stop and abort on various conditions. The following flags are available:

    //    empty_output
    //    No packets were passed to the muxer, the output is empty.
    //
    //    empty_output_stream
    //    No packets were passed to the muxer in some of the output streams.

    /// Set fraction of decoding frame failures across all inputs which when crossed ffmpeg will return exit code 69. Crossing this threshold does not terminate processing. Range is a floating-point number between 0 to 1. Default is 2/3.
    public var maxErrorRate: Double?

    /// Stop and exit on error
    public var stopAndExitOnError: Bool

    /// Enable automatically inserting format conversion filters in all filter graphs, including those defined by -vf, -af, -filter_complex and -lavfi. If filter format negotiation requires a conversion, the initialization of the filters will fail. Conversions can still be performed by inserting the relevant conversion filter (scale, aresample) in the graph. On by default, to explicitly disable it you need to specify -noauto_conversion_filters.
    public var noAutoConversionFilters: Bool

    /// Set period at which encoding progress/statistics are updated. Default is 0.5 seconds.
    public var statsPeriod: Double?

    /// Send program-friendly progress information to url.
    public var progressUrl: String?

    ///Enable interaction on standard input. On by default unless standard input is used as an input. To explicitly disable interaction you need to specify -nostdin.
    ///Disabling interaction on standard input is useful, for example, if ffmpeg is in the background process group. Roughly the same result can be achieved with ffmpeg ... < /dev/null but it requires a shell.
    public var enableStdin: Bool

    /// Print timestamp information. It is off by default. This option is mostly useful for testing and debugging purposes, and the output format may change from one version to another, so it should not be employed by portable scripts.
    /// See also the option -fdebug ts.
    public var debugTimestamp: Bool

    /// Show benchmarking information at the end of an encode. Shows real, system and user time used and maximum memory consumption. Maximum memory consumption is not supported on all systems, it will usually display as 0 if not supported.
    public var benchmark: Bool

    /// Show benchmarking information during the encode. Shows real, system and user time used in various steps (audio/video encode/decode).
    public var benchmarkAll: Bool

    /// Exit after ffmpeg has been running for duration seconds in CPU user time.
    public var timelimit: Double?

    /// Dump each input packet to stderr.
    public var dumpPacket: Bool

    /// When dumping packets, also dump the payload.
    public var dumpHex: Bool

    /// Show QP histogram
    public var showQPHistogram: Bool

    public var initHardwareDevices: [HardwareDevice]

    var arguments: [String] {
      var builder = ArgumentBuilder()
      builder.add(flag: "-loglevel", value: logLevel)
      builder.add(flag: "-hide_banner", when: hideBanner)
      builder.add(flag: "-cpuflags", value: cpuflags)
      builder.add(flag: "-filter_threads", value: filterThreadNumber)
      builder.add(flag: "--filter_complex_threads", value: filterComplexThreadNumber)
      if let overwrite = self.overwrite {
        builder.add(flag: "-\(overwrite ? "y" : "n")")
      }
      builder.add(flag: "-filter_complex_script", value: filterComplextScriptFilename)
      builder.add(flag: "-sdp_file", value: sdpFile)
      builder.add(flag: "-nostats", when: !stats)
      builder.add(flag: "-filter_complex", value: filtergraph)
      builder.add(flag: "-xerror", when: stopAndExitOnError)
      builder.add(flag: "-noauto_conversion_filters", when: noAutoConversionFilters)
      builder.add(flag: "-stats_period", value: statsPeriod)
      builder.add(flag: "-debug_ts", when: debugTimestamp)
      builder.add(flag: "-benchmark", when: benchmark)
      builder.add(flag: "-benchmark_all", when: benchmarkAll)
      builder.add(flag: "-timelimit", value: timelimit)
      builder.add(flag: "-dump", when: dumpPacket)
      builder.add(flag: "-hex", when: dumpHex)
      builder.add(flag: "-qphist", when: showQPHistogram)
      builder.add(flag: "-max_error_rate", value: maxErrorRate)
      builder.add(flag: "-progress", value: progressUrl)
      builder.add(flag: "-nostdin", when: !enableStdin)
      initHardwareDevices.forEach { hwDevice in
        builder.add(flag: "-init_hw_device", value: hwDevice)
      }
      return builder.arguments
    }

    public struct LogLevel: CustomArgumentConvertible {
      public init(enabledFlags: [Flag] = [], disabledFlags: [Flag] = [], level: Level? = nil) {
        self.enabledFlags = enabledFlags
        self.disabledFlags = disabledFlags
        self.level = level
      }

      var argument: String {
        var result = ""
        enabledFlags.forEach { flag in
          result += "+"
          result += flag.rawValue
        }
        disabledFlags.forEach { flag in
          result += "-"
          result += flag.rawValue
        }
        if let level = level {
          if !result.isEmpty {
            result += "+"
          }
          result += level.rawValue
        }
        return result
      }

      public var enabledFlags: [Flag]
      public var disabledFlags: [Flag]
      public var level: Level?

      public struct Flag: RawRepresentable {
        public init(rawValue: String) {
          self.rawValue = rawValue
        }

        public let rawValue: String
      }

      public struct Level: RawRepresentable {
        public init(rawValue: String) {
          self.rawValue = rawValue
        }

        public let rawValue: String
      }
    }

    public struct HardwareDevice: CustomArgumentConvertible {
      var argument: String {
        var result = type.rawValue
        if !name.isEmpty {
          result += "="
          result += name
        }
        if let device = device {
          switch device {
          case .create(let device, let parameters):
            result += ":"
            result += device
            parameters.forEach { parameter in
              result += ","
              result += parameter.key
              result += "="
              result += parameter.value
            }
          case .derive(let sourceName):
            result += "@"
            result += sourceName
          }
        }
        return result
      }

      public init(type: HardwareType, name: String = "", device: DeviceType? = nil) {
        self.type = type
        self.name = name
        self.device = device
      }

      public var type: HardwareType
      public var name: String
      public var device: DeviceType?

      public struct HardwareType: RawRepresentable, ExpressibleByStringLiteral {

        public init(stringLiteral value: String) {
          self.init(rawValue: value)
        }

        public init(rawValue: String) {
          self.rawValue = rawValue
        }

        public let rawValue: String

        public static let videotoolbox: Self = "videotoolbox"
      }

      public enum DeviceType {
        case create(device: String, parameters: [String: String])
        case derive(sourceName: String)
      }
    }
  }
}

// MARK: Input/Output Options
extension FFmpeg {
  public struct Input {
    public init(url: String, options: [FFmpeg.InputOption] = []) {
      self.url = url
      self.options = options
    }
    
    public var url: String
    public var options: [InputOption]

  }

  public struct Output {
    public init(url: String, options: [FFmpeg.OutputOption] = []) {
      self.url = url
      self.options = options
    }

    public var url: String
    public var options: [OutputOption]
  }

  public enum StrictLevel: Int {
    case very = 2
    case strict = 1
    case normal = 0
    case unofficial = -1
    case experimental = -2
  }

  public enum MetadataSpecifier {
    case global
    case stream(StreamSpecifier?)
    case chapterIndex(Int)
    case programIndex(Int)

    @usableFromInline
    var argument: String {
      switch self {
      case .global:
        return ":g"
      case .stream(let optional):
        return ":s\(optional?.argument ?? "")"
      case .chapterIndex(let int):
        return ":c:\(int)"
      case .programIndex(let int):
        return ":p:\(int)"
      }
    }
  }

  /// Some options are applied per-stream, e.g. bitrate or codec. Stream specifiers are used to precisely specify which stream(s) a given option belongs to.
  public indirect enum StreamSpecifier {
    case streamIndex(Int)
    case streamType(StreamType, additional: Self?)
    case programID(Int, additional: Self?)
    case streamID(Int)
    case matchMetadata(key: String, value: String?)
    case usable

    public static func streamType(_ streamType: StreamType) -> Self {
      .streamType(streamType, additional: nil)
    }

    public static func programID(_ programID: Int) -> Self {
      .programID(programID, additional: nil)
    }

    /// argument string, including the prefix ':'
    @usableFromInline
    var argument: String {
      switch self {
      case .matchMetadata(let key, let value):
        return ":m:\(key)\(value.map {":\($0)"} ?? "")"
      case .programID(let id, let additional):
        return ":p:\(id)\(additional?.argument ?? "")"
      case .streamID(let id):
        return ":i:\(id)"
      case .streamIndex(let index):
        return ":\(index)"
      case .streamType(let type, let additional):
        return ":\(type.streamSpecifier)\(additional?.argument ?? "")"
      case .usable:
        return ":u"
      }
    }
  }

  public enum StreamType {
    case video
    case videoNotPicture
    case audio
    case subtitle
    case data
    case attachment

    @usableFromInline
    var streamSpecifier: String {
      switch self {
      case .attachment: return "t"
      case .audio: return "a"
      case .data: return "d"
      case .subtitle: return "s"
      case .video: return "v"
      case .videoNotPicture: return "V"
      }
    }
  }
}

// TODO: rename to nested protocol FFmpeg.IOOptions
public protocol _FFmpegIOOptions {
  init(flag: String, value: String?)
  var flag: String { get }
  var value: String? { get }
}

extension FFmpeg {
  public struct InputOption: _FFmpegIOOptions  {
    public let flag: String
    public let value: String?

    @_alwaysEmitIntoClient
    public init(flag: String, value: String?) {
      self.flag = flag
      self.value = value
    }
  }

  public struct OutputOption: _FFmpegIOOptions  {
    public let flag: String
    public let value: String?

    @_alwaysEmitIntoClient
    public init(flag: String, value: String?) {
      self.flag = flag
      self.value = value
    }
  }
}

public extension _FFmpegIOOptions {
  @inlinable
  init(name: String, _ streamSpecifier: FFmpeg.StreamSpecifier?, _ value: String) {
    self.init(flag: "-\(name)\(streamSpecifier?.argument ?? "")", value: value)
  }
}

public extension FFmpeg.InputOption {
  /// Set number of times input stream shall be looped. Loop 0 means no loop, loop -1 means infinite loop.
  @inlinable static func streamLoop(_ value: Int) -> Self {
    .init(flag: "-stream_loop", value: value.description)
  }

  @inlinable static func hardwareAcceleration(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "-hwaccel", streamSpecifier, value)
  }

  @inlinable static func reinitFilter(_ value: Bool, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "-reinit_filter", streamSpecifier, value ? "1" : "0")
  }
}
public extension FFmpeg.OutputOption {
  // TODO: sync_file_id not implement
  @inlinable static func map(inputFileID: Int, streamSpecifier: FFmpeg.StreamSpecifier?, isOptional: Bool, isNegativeMapping: Bool) -> Self {
    var argument = isNegativeMapping ? "-" : ""
    argument.append(inputFileID.description)
    streamSpecifier.map { argument.append($0.argument) }
    if isOptional {
      argument.append("?")
    }
    return .init(flag: "-map", value: argument)
  }

  /// Create the filtergraph specified by filtergraph and use it to filter the stream.
  @inlinable static func filter(filtergraph: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "filter", streamSpecifier, filtergraph)
  }

  @inlinable static func bitrate(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier) -> Self {
    .init(name: "b", streamSpecifier, value)
  }

  @inlinable static func colorspace(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "colorspace", streamSpecifier, value)
  }

  @inlinable static func colorPrimaries(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "color_primaries", streamSpecifier, value)
  }

  @inlinable static func colorTransferCharacteristics(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "color_trc", streamSpecifier, value)
  }

  /// set inputFileIndex to -1 to strip all metadata
  @inlinable static func mapMetadata(outputSpec: FFmpeg.MetadataSpecifier?, inputFileIndex: Int, inputSpec: FFmpeg.MetadataSpecifier?) -> Self {
    .init(flag: "-map_metadata\(outputSpec?.argument ?? "")", value: "\(inputFileIndex)\(inputSpec?.argument ?? "")")
  }

  @inlinable static func mapChapters(inputFileIndex: Int) -> Self {
    .init(flag: "-map_chapters", value: inputFileIndex.description)
  }

  @inlinable static func frameCount(_ value: Int, streamSpecifier: FFmpeg.StreamSpecifier) -> Self {
    .init(name: "frames", streamSpecifier, value.description)
  }
}

public extension _FFmpegIOOptions {
  /// Force input or output file format. The format is normally auto detected for input files and guessed from the file extension for output files, so this option is not needed in most cases.
  @inlinable static func format(_ value: String) -> Self {
    .init(flag: "f", value: value)
  }
  /*
   Select an encoder (when used before an output file) or a decoder (when used before an input file) for one or more streams. codec is the name of a decoder/encoder or a special value copy (output only) to indicate that the stream is not to be re-encoded.

   For example

   ffmpeg -i INPUT -map 0 -c:v libx264 -c:a copy OUTPUT
   encodes all video streams with libx264 and copies all audio streams.

   For each stream, the last matching c option is applied, so

   ffmpeg -i INPUT -map 0 -c copy -c:v:1 libx264 -c:a:137 libvorbis OUTPUT
   will copy all the streams except the second video, which will be encoded with libx264, and the 138th audio, which will be encoded with libvorbis.
   */
  @inlinable static func codec(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier? = nil) -> Self {
    .init(name: "c", streamSpecifier, value)
  }

  /// When used as an input option (before -i), limit the duration of data read from the input file.
  /// When used as an output option (before an output url), stop writing the output after its duration reaches duration.
  /// duration must be a time duration specification, see (ffmpeg-utils)the Time duration section in the ffmpeg-utils(1) manual.
  /// -to and -t are mutually exclusive and -t has priority.
  @inlinable static func duration(_ value: String) -> Self {
    .init(flag: "-t", value: value)
  }
  @inlinable static func startPosition(_ value: String) -> Self {
    .init(flag: "-ss", value: value)
  }
  @inlinable static func endPosition(_ value: String) -> Self {
    .init(flag: "-to", value: value)
  }

  @inlinable static func frameSize(width: Int32, height: Int32, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "s", streamSpecifier, "\(width)x\(height)")
  }

  /// Set the number of audio channels. For output streams it is set by default to the number of input audio channels. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.
  @inlinable static func audioChannels(_ value: Int, streamSpecifier: FFmpeg.StreamSpecifier? = nil) -> Self {
    .init(name: "ac", streamSpecifier, value.description)
  }
  @inlinable static func strict(level: FFmpeg.StrictLevel) -> Self {
    .init(flag: "-strict", value: level.rawValue.description)
  }
  /// Set pixel format. Use -pix_fmts to show all the supported pixel formats. If the selected pixel format can not be selected, ffmpeg will print a warning and select the best pixel format supported by the encoder. If pix_fmt is prefixed by a +, ffmpeg will exit with an error if the requested pixel format can not be selected, and automatic conversions inside filtergraphs are disabled. If pix_fmt is a single +, ffmpeg selects the same pixel format as the input (or graph output) and automatic conversions are disabled.
  @inlinable static func pixelFormat(_ value: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: "pix_fmt", streamSpecifier, value)
  }

  @inlinable static func avOption(name: String, value: String, streamSpecifier: FFmpeg.StreamSpecifier?) -> Self {
    .init(name: name, streamSpecifier, value)
  }

  @available(*, unavailable)
  @inlinable static func nonStdOptions(_ value: [String : String]) -> Self {
    fatalError()
  }

  @inlinable static func raw(_ value: String) -> Self {
    .init(flag: value, value: nil)
  }
}


extension FFmpeg.GlobalOptions.LogLevel.Flag: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(rawValue: value)
  }
}

public extension FFmpeg.GlobalOptions.LogLevel.Flag {
  @_alwaysEmitIntoClient
  static var `repeat`: Self { "repeat" }

  @_alwaysEmitIntoClient
  static var level: Self { "level" }
}

extension FFmpeg.GlobalOptions.LogLevel.Level: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(rawValue: value)
  }
}

public extension FFmpeg.GlobalOptions.LogLevel.Level {
  @inlinable
  @_alwaysEmitIntoClient
  static var quiet: Self { "quiet" }

  @inlinable
  @_alwaysEmitIntoClient
  static var panic: Self { "panic" }

  @inlinable
  @_alwaysEmitIntoClient
  static var fatal: Self { "fatal" }

  @inlinable
  @_alwaysEmitIntoClient
  static var error: Self { "error" }

  @inlinable
  @_alwaysEmitIntoClient
  static var warning: Self { "warning" }

  @inlinable
  @_alwaysEmitIntoClient
  static var info: Self { "info" }

  @inlinable
  @_alwaysEmitIntoClient
  static var verbose: Self { "verbose" }

  @inlinable
  @_alwaysEmitIntoClient
  static var debug: Self { "debug" }

  @inlinable
  @_alwaysEmitIntoClient
  static var trace: Self { "trace" }
}
