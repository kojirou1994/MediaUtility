import Foundation
import ExecutableDescription

public struct FFmpeg: Executable {
  public init(global: GlobalOptions = .init(), ios: [FFmpeg.FFmpegIO] = []) {
    self.global = global
    self.ios = ios
  }

  public static let executableName: String = "ffmpeg"

  public let global: GlobalOptions

  public var ios: [FFmpegIO]

  public var arguments: [String] {
    var args = [String]()
    args.append(contentsOf: global.arguments)
    ios.forEach { io in
      args.append(contentsOf: io.arguments)
    }
    return args
  }

}

// MARK: Global Options
extension FFmpeg {
  public struct GlobalOptions {
    public init(
      hideBanner: Bool = false,
      cpuflags: String? = nil, overwrite: Bool? = nil, filterThreadNumber: Int? = nil,
      stats: Bool = true, filterComplexThreadNumber: Int? = nil, filtergraph: String? = nil,
      filterComplextScriptFilename: String? = nil, sdpFile: String? = nil,
      maxErrorRate: Double? = nil, stopAndExitOnError: Bool = false,
      noAutoConversionFilters: Bool = false, statsPeriod: Double? = nil,
      enableStdin: Bool = true,
      progressUrl: String? = nil, debugTimestamp: Bool = false, benchmark: Bool = false,
      benchmarkAll: Bool = false, timelimit: Double? = nil, dumpPacket: Bool = false,
      dumpHex: Bool = false, showQPHistogram: Bool = false) {
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
    }

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

    var arguments: [String] {
      var builder = ArgumentBuilder()
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
      return builder.arguments
    }
  }
}

// MARK: Input/Output Options
extension FFmpeg {
  public struct FFmpegIO {
    public static func input(url: String, options: [InputOutputOption] = []) -> Self {
      .init(url: url, isInput: true, options: options)
    }

    public static func output(url: String, options: [InputOutputOption] = []) -> Self {
      .init(url: url, isInput: false, options: options)
    }

    public var url: String
    public let isInput: Bool
    public var options: [InputOutputOption]

    public var isOutput: Bool { !isInput }

    var arguments: [String] {

      func flag(_ name: String, _ streamSpecifier: StreamSpecifier? = nil) -> String {
        "-\(name)\(streamSpecifier?.argument ?? "")"
      }

      var builder = ArgumentBuilder()
      options.forEach { option in
        switch option {
        case let .codec(codec, streamSpecifier: streamSpecifier):
          builder.add(flag: flag("c", streamSpecifier), value: codec)
        case .format(let format):
          builder.add(flag: flag("f"), value: format)
        case .streamLoop(let number):
          precondition(isInput)
          builder.add(flag: flag("stream_loop"), value: number)
        case .duration(let duration):
          builder.add(flag: flag("t"), value: duration)
        case .map(inputFileID: let inputFileID, streamSpecifier: let streamSpecifier,
                  isOptional: let isOptional, isNegativeMapping: let isNegativeMapping):
          precondition(isOutput)
          var argument = isNegativeMapping ? "-" : ""
          argument.append(inputFileID.description)
          streamSpecifier.map { argument.append($0.argument) }
          if isOptional {
            argument.append("?")
          }
          builder.add(flag: "-map", value: argument)
        case .filter(filtergraph: let filtergraph, streamSpecifier: let streamSpecifier):
          precondition(isOutput)
          builder.add(flag: flag("filter", streamSpecifier), value: filtergraph)
        case .audioChannels(let number, streamSpecifier: let streamSpecifier):
          builder.add(flag: flag("ac", streamSpecifier), value: number)
        case .strict(let level):
          builder.add(flag: "-strict", value: level.rawValue)
        case let .bitrate(bitrate, streamSpecifier: streamSpecifier):
          precondition(isOutput)
          builder.add(flag: flag("b", streamSpecifier), value: bitrate)
        case .pixelFormat(let pixelFormat, streamSpecifier: let streamSpecifier):
          builder.add(flag: flag("pix_fmt", streamSpecifier), value: pixelFormat)
        case .colorspace(let colorspace, streamSpecifier: let streamSpecifier):
          precondition(isOutput)
          builder.add(flag: flag("colorspace", streamSpecifier), value: colorspace)
        case .colorPrimaries(let colorPrimaries, streamSpecifier: let streamSpecifier):
          precondition(isOutput)
          builder.add(flag: flag("color_primaries", streamSpecifier), value: colorPrimaries)
        case .colorTransferCharacteristics(let value, streamSpecifier: let streamSpecifier):
          precondition(isOutput)
          builder.add(flag: flag("color_trc", streamSpecifier), value: value)
        case .mapMetadata(outputSpec: let outputSpec, inputFileIndex: let inputFileIndex, inputSpec: let inputSpec):
          precondition(isOutput)
          builder.add(flag: "-map_metadata\(outputSpec?.argument ?? "")", value: "\(inputFileIndex)\(inputSpec?.argument ?? "")")
        case .mapChapters(inputFileIndex: let inputFileIndex):
          precondition(isOutput)
          builder.add(flag: "-map_chapters", value: inputFileIndex)
        case .avOption(name: let name, value: let value, streamSpecifier: let streamSpecifier):
          builder.add(flag: flag(name, streamSpecifier), value: value)
        case .nonStdOptions(let options):
          options.forEach { (key, value) in
            builder.add(flag: flag(key), value: value)
          }
        }
      }

      if isInput {
        builder.add(flag: "-i", value: url)
      } else {
        builder.add(flag: url)
      }
      return builder.arguments
    }
  }

  public enum InputOutputOption {
    /// Force input or output file format. The format is normally auto detected for input files and guessed from the file extension for output files, so this option is not needed in most cases.
    case format(String)
    /// Set number of times input stream shall be looped. Loop 0 means no loop, loop -1 means infinite loop.
    case streamLoop(Int)
    /*
     Select an encoder (when used before an output file) or a decoder (when used before an input file) for one or more streams. codec is the name of a decoder/encoder or a special value copy (output only) to indicate that the stream is not to be re-encoded.

     For example

     ffmpeg -i INPUT -map 0 -c:v libx264 -c:a copy OUTPUT
     encodes all video streams with libx264 and copies all audio streams.

     For each stream, the last matching c option is applied, so

     ffmpeg -i INPUT -map 0 -c copy -c:v:1 libx264 -c:a:137 libvorbis OUTPUT
     will copy all the streams except the second video, which will be encoded with libx264, and the 138th audio, which will be encoded with libvorbis.
     */
    case codec(String, streamSpecifier: StreamSpecifier?)
    case bitrate(String, streamSpecifier: StreamSpecifier)
    /// When used as an input option (before -i), limit the duration of data read from the input file.
    /// When used as an output option (before an output url), stop writing the output after its duration reaches duration.
    /// duration must be a time duration specification, see (ffmpeg-utils)the Time duration section in the ffmpeg-utils(1) manual.
    /// -to and -t are mutually exclusive and -t has priority.
    case duration(String)
    // TODO: sync_file_id not implement
    case map(inputFileID: Int, streamSpecifier: StreamSpecifier?, isOptional: Bool, isNegativeMapping: Bool)
    /// Create the filtergraph specified by filtergraph and use it to filter the stream.
    case filter(filtergraph: String, streamSpecifier: StreamSpecifier?)
    /// Set the number of audio channels. For output streams it is set by default to the number of input audio channels. For input streams this option only makes sense for audio grabbing devices and raw demuxers and is mapped to the corresponding demuxer options.
    case audioChannels(Int, streamSpecifier: StreamSpecifier?)
    case strict(level: StrictLevel)
    /// Set pixel format. Use -pix_fmts to show all the supported pixel formats. If the selected pixel format can not be selected, ffmpeg will print a warning and select the best pixel format supported by the encoder. If pix_fmt is prefixed by a +, ffmpeg will exit with an error if the requested pixel format can not be selected, and automatic conversions inside filtergraphs are disabled. If pix_fmt is a single +, ffmpeg selects the same pixel format as the input (or graph output) and automatic conversions are disabled.
    case pixelFormat(String, streamSpecifier: StreamSpecifier?)
    case colorspace(String, streamSpecifier: StreamSpecifier?)
    case colorPrimaries(String, streamSpecifier: StreamSpecifier?)
    case colorTransferCharacteristics(String, streamSpecifier: StreamSpecifier?)
    case mapMetadata(outputSpec: MetadataSpecifier?, inputFileIndex: Int, inputSpec: MetadataSpecifier?)
    case mapChapters(inputFileIndex: Int)

    case avOption(name: String, value: String, streamSpecifier: StreamSpecifier?)
    case nonStdOptions([String : String])

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
