import Foundation
import ExecutableDescription

public struct FFmpeg: Executable {
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
    public init(cpuflags: String? = nil, overwrite: Bool? = false, filterThreadNumber: Int? = nil, stats: Bool = true, filterComplexThreadNumber: Int? = nil, filtergraph: String? = nil, filterComplextScriptFilename: String? = nil, sdpFile: String? = nil, maxErrorRate: Double? = nil, stopAndExitOnError: Bool, autoConversionFilters: Bool, statsPeriod: Double, progressUrl: String? = nil, debugTimestamp: Bool = false, benchmark: Bool = false, benchmarkAll: Bool = false, timelimit: Double? = nil, dumpPacket: Bool = false, dumpHex: Bool = false, showQPHistogram: Bool = false) {
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
      self.autoConversionFilters = autoConversionFilters
      self.statsPeriod = statsPeriod
      self.progressUrl = progressUrl
      self.debugTimestamp = debugTimestamp
      self.benchmark = benchmark
      self.benchmarkAll = benchmarkAll
      self.timelimit = timelimit
      self.dumpPacket = dumpPacket
      self.dumpHex = dumpHex
      self.showQPHistogram = showQPHistogram
    }

    public var cpuflags: String?

    /// Overwrite output files without asking.
    public var overwrite: Bool? = false

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
    public var autoConversionFilters: Bool

    /// Set period at which encoding progress/statistics are updated. Default is 0.5 seconds.
    public var statsPeriod: Double

    /// Send program-friendly progress information to url.
    public var progressUrl: String?

    /// Print timestamp information. It is off by default. This option is mostly useful for testing and debugging purposes, and the output format may change from one version to another, so it should not be employed by portable scripts.
    /// See also the option -fdebug ts.
    public var debugTimestamp: Bool = false

    /// Show benchmarking information at the end of an encode. Shows real, system and user time used and maximum memory consumption. Maximum memory consumption is not supported on all systems, it will usually display as 0 if not supported.
    public var benchmark: Bool = false

    /// Show benchmarking information during the encode. Shows real, system and user time used in various steps (audio/video encode/decode).
    public var benchmarkAll: Bool = false

    /// Exit after ffmpeg has been running for duration seconds in CPU user time.
    public var timelimit: Double?

    /// Dump each input packet to stderr.
    public var dumpPacket: Bool = false

    /// When dumping packets, also dump the payload.
    public var dumpHex: Bool = false

    /// Show QP histogram
    public var showQPHistogram: Bool = false

    var arguments: [String] {
      var builder = ArgumentBuilder()
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
      builder.add(flag: "-auto_conversion_filters", when: autoConversionFilters)
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
    let isInput: Bool
    public var options: [InputOutputOption]

    var arguments: [String] {
      var builder = ArgumentBuilder()
      options.forEach { option in
        switch option {
        case let .codec(codec, streamSpecifier: streamSpecifier):
          builder.add(flag: "-c\(streamSpecifier?.argument ?? "")", value: codec)
        case .format(let format):
          builder.add(flag: "-f", value: format)
        case .streamLoop(let number):
          builder.add(flag: "-stream_loop", value: number)
        case .duration(let duration):
          builder.add(flag: "-t", value: duration)
        case .nonStdOptions(let options):
          options.forEach { (key, value) in
            builder.add(flag: "-\(key)", value: value)
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
    /// When used as an input option (before -i), limit the duration of data read from the input file.
    /// When used as an output option (before an output url), stop writing the output after its duration reaches duration.
    /// duration must be a time duration specification, see (ffmpeg-utils)the Time duration section in the ffmpeg-utils(1) manual.
    /// -to and -t are mutually exclusive and -t has priority.
    case duration(String)

    case nonStdOptions([String : String])
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
