import Foundation
import ExecutableDescription
import MediaUtility

public struct MkvMerge: Executable {

  public init(global: GlobalOption, output: String, inputs: [Input]) {
    self.global = global
    self.output = output
    self.inputs = inputs
  }

  public static var executableName: String { "mkvmerge" }

  public var global: GlobalOption

  public var output: String

  public var inputs: [Input]

  public var arguments: [String] {

    var builder = ArgumentBuilder()
    builder.append(argumentsFrom: global.arguments)
    builder.add(flag: "--output", value: output)
    inputs.forEach { input in
      builder.append(argumentsFrom: input.arguments)
    }

    if builder.arguments.count >= 4096 {
      let optionsFile = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent("\(UUID().uuidString).json")
      try! JSONSerialization.data(
        withJSONObject: builder.arguments, options: [.prettyPrinted]
      ).write(to: optionsFile)
      return ["@\(optionsFile.path)"]
    } else {
      return builder.arguments
    }
  }

}

// MARK: GlobalOption
extension MkvMerge {
  public struct GlobalOption {

    public init(verbose: Bool = false, quiet: Bool, webm: Bool = false, title: String? = nil, defaultLanguage: String? = nil, chapterLanguage: String? = nil, chapterFile: String? = nil, generateChaptersMode: MkvMerge.GlobalOption.GenerateChaptersMode? = nil, chaptersNameTemplate: MkvMerge.GlobalOption.ChaptersNameTemplate? = nil, trackOrder: [MkvMerge.GlobalOption.TrackOrder]? = nil, split: MkvMerge.GlobalOption.Split? = nil, flushOnClose: Bool = false, debug: String? = nil, experimentalFeatures: [MkvMerge.GlobalOption.ExperimentFeature]? = nil) {
      self.verbose = verbose
      self.quiet = quiet
      self.webm = webm
      self.title = title
      self.defaultLanguage = defaultLanguage
      self.chapterLanguage = chapterLanguage
      self.chapterFile = chapterFile
      self.generateChaptersMode = generateChaptersMode
      self.chaptersNameTemplate = chaptersNameTemplate
      self.trackOrder = trackOrder
      self.split = split
      self.flushOnClose = flushOnClose
      self.debug = debug
      self.experimentalFeatures = experimentalFeatures
    }

    // 2.1. Global options
    public var verbose: Bool
    public var quiet: Bool
    public var webm: Bool
    public var title: String?
    public var defaultLanguage: String?

    // 2.2. Segment info handling (global options)
    private var segmentinfo: String?
    private var segmentUID: String?

    // 2.3. Chapter and tag handling (global options)
    public var chapterLanguage: String?
    public var generateChaptersMode: GenerateChaptersMode?
    public var chaptersNameTemplate: ChaptersNameTemplate?
    public var chapterFile: String?
    public var globalTagsFile: String?

    // 2.4. General output control (advanced global options)
    public var trackOrder: [TrackOrder]?

    // 2.5. File splitting, linking, appending and concatenation (more global options)
    public var split: Split?
    public var appendMode: AppendMode?

    // Other options
    /// Tells the program to flush all data cached in memory to storage when closing files opened for writing.
    public var flushOnClose: Bool
    /// Turns on debugging output
    public var debug: String?
    /// Turns on experimental feature
    public var experimentalFeatures: [ExperimentFeature]?

    public enum ChaptersNameTemplate: ExpressibleByStringLiteral {
      case raw(String)
      case components([TemplateComponent])

      public init(stringLiteral value: String) {
        self = .raw(value)
      }

      public enum TemplateComponent: ExpressibleByStringLiteral {

        case chapterNumber(padding: Int?)
        case chapterTimestamp(formats: [ChapterTimestampFormat])
        case filename
        case filenameWithExt
        case raw(String)

        public init(stringLiteral value: String) {
          self = .raw(value)
        }

        public enum ChapterTimestampFormat: ExpressibleByStringLiteral {

          case hours
          case hoursPadded
          case minutes
          case minutesPadded
          case seconds
          case secondsPadded
          case nanosecondsPadded
          case nanoseconds(padding: Int)
          case raw(String)

          public init(stringLiteral value: String) {
            self = .raw(value)
          }

          var argument: String {
            switch self {
            case .hours: return "%h"
            case .hoursPadded: return "%H"
            case .minutes: return "%m"
            case .minutesPadded: return "%M"
            case .nanoseconds(let padding):
              assert((1...9).contains(padding))
              let fixed = min(9, max(1, padding))
              return "%\(fixed)n"
            case .nanosecondsPadded: return "%n"
            case .raw(let raw): return raw
            case .seconds: return "%s"
            case .secondsPadded: return "%S"
            }
          }
        }

        var argument: String {
          switch self {
          case .chapterNumber(let padding):
            if let v = padding, v > 0 {
              return "<NUM:\(v)>"
            }
            return "<NUM>"
          case .chapterTimestamp(let formats):
            return formats.map(\.argument).joined()
          case .filename:
            return "<FILE_NAME>"
          case .filenameWithExt:
            return "<FILE_NAME_WITH_EXT>"
          case .raw(let raw):
            return raw
          }
        }

      }

      var argument: String {
        switch self {
        case .raw(let raw):
          return raw
        case .components(let components):
          return components.map(\.argument).joined(separator: "")
        }
      }
    }

    public enum GenerateChaptersMode {
      case whenAppending
      case interval(Split.DurationSplit)

      var argument: String {
        switch self {
        case .whenAppending:
          return "when-appending"
        case .interval(let timeSpec):
          return "interval:\(timeSpec.argument)"
        }
      }
    }

    public enum ExperimentFeature: String {
      case space_after_chapters
      case no_chapters_in_meta_seek
      case no_meta_seek
      case lacing_xiph
      case lacing_ebml
      case native_mpeg4
      case no_variable_data
      case force_passthrough_packetizer
      case write_headers_twice
      case allow_avc_in_vfw_mode
      case keep_bitstream_ar_info
      case no_simpleblocks
      case use_codec_state_only
      case enable_timestamp_warning
      case remove_bitstream_ar_info
      case vobsub_subpic_stop_cmds
      case no_cue_duration
      case no_cue_relative_position
      case no_delay_for_garbage_in_avi
      case keep_last_chapter_in_mpls
      case keep_track_statistics_tags
      case all_i_slices_are_key_frames
      case append_and_split_flac
      case dont_normalize_parameter_sets
      case cow
    }

    public enum Split {
      /// Splitting by size in bytes
      case size(Int)
      /// Splitting after a duration.
      case duration(DurationSplit)
      /// Splitting after specific timestamps.
      case timestamps([DurationSplit])
      /// Splitting after specific frames/fields.
      case frames([Int])
      /// Splitting before specific chapters.
      case chapters(ChapterSplit)

      public enum DurationSplit {
        case timestamp(Timestamp)
        case second(Int)

        var argument: String {
          switch self {
          case .second(let second):
            return "\(second)s"
          case .timestamp(let timestamp):
            return "duration:\(timestamp)"
          }
        }
      }

      public enum ChapterSplit {
        case all
        case numbers([Int])
      }

      var argument: String {
        switch self {
        case .size(let bytes):
          return String(describing: bytes)
        case .duration(let duration):
          return duration.argument
        case .timestamps(let timestamps):
          return "timestamps:\(timestamps.map(\.argument).joined(separator: ","))"
        case .frames(let frames):
          return "frames:\(frames.map(\.description).joined(separator: ","))"
        case .chapters(.all):
          return "chapters:all"
        case .chapters(.numbers(let numbers)):
          return "chapters:\(numbers.map{String(describing: $0)}.joined(separator: ","))"
        }
      }
    }

    public enum AppendMode: String, CaseIterable, Codable {
      case file
      case track

      var argument: String { rawValue }
    }

    public struct TrackOrder {
      public var fid: Int
      public var tid: Int

      var argument: String { "\(fid):\(tid)" }

      public init(fid: Int, tid: Int) {
        self.fid = fid
        self.tid = tid
      }
    }

    var arguments: [String] {
      var builder = ArgumentBuilder()
      builder.add(flag: "--verbose", when: verbose)
      builder.add(flag: "--quiet", when: quiet)
      builder.add(flag: "--webm", when: webm)
      builder.add(flag: "--title", value: title)
      builder.add(flag: "--default-language", value: defaultLanguage)

      builder.add(flag: "--segmentinfo", value: segmentinfo)
      builder.add(flag: "--segment-uid", value: segmentUID)

      builder.add(flag: "--chapter-language", value: chapterLanguage)
      builder.add(flag: "--generate-chapters", value: generateChaptersMode?.argument)
      builder.add(flag: "--generate-chapters-name-template", value: chaptersNameTemplate?.argument)
      builder.add(flag: "--chapters", value: chapterFile)
      builder.add(flag: "--global-tags", value: globalTagsFile)

      builder.add(flag: "--track-order", value: trackOrder?.map(\.argument).joined(separator: ","))

      builder.add(flag: "--split", value: split?.argument)
      builder.add(flag: "--append-mode", value: appendMode?.argument)

      builder.add(flag: "--flush-on-close", when: flushOnClose)
      builder.add(flag: "--debug", value: debug)
      builder.add(flag: "--engage", value: experimentalFeatures?.map(\.rawValue).joined(separator: ","))

      return builder.arguments
    }
  }
}

// MARK: Input
extension MkvMerge {
  public struct Input {
    public enum InputOption {
      public enum TrackSelect {
        case empty
        case removeAll
        case enabledTIDs([Int])
        case enabledLANGs(Set<String>)
        case disabledTIDs([Int])
        case disabledLANGS(Set<String>)

        var checked: TrackSelect {
          switch self {
          case .enabledTIDs(let tids), .disabledTIDs(let tids):
            if tids.isEmpty {
              return .empty
            } else {
              return self
            }
          case .enabledLANGs(let langs), .disabledLANGS(let langs):
            if langs.isEmpty {
              return .empty
            } else {
              return self
            }
          default: return self
          }
        }

        var argument: String {
          switch self {
          case .enabledTIDs(let tids):
            return tids.map { String(describing: $0) }.joined(separator: ",")
          case .disabledTIDs(let tids):
            return "!"
              + tids.map { String(describing: $0) }.joined(separator: ",")
          case .enabledLANGs(let langs):
            return langs.joined(separator: ",")
          case .disabledLANGS(let langs):
            return "!" + langs.joined(separator: ",")
          default:
            fatalError()
          }
        }

      }

      public enum Flag: String {
        case defaultTrack = "default-track"
        case trackEnabled = "track-enabled"
        case forcedDisplay = "forced-display"
        case hearingImpaired = "hearing-impaired"
        case visualImpaired = "visual-impaired"
        case textDescriptions = "text-descriptions"
        case original
        case commentary
      }

      case audioTracks(TrackSelect)
      case videoTracks(TrackSelect)
      case subtitleTracks(TrackSelect)
      case buttonTracks(TrackSelect)
      case trackTags(TrackSelect)
      case attachments(TrackSelect)
      case noChapters
      case noGlobalTags
//      case sync(tid: Int, d: Double, o: Double?, p: Double?)
//      case cues(tid: Int, String) // none|iframes|all
      case flag(tid: Int, Flag, Bool)
      case trackName(tid: Int, name: String)
      case language(tid: Int, language: String)

      var arguments: [String] {
        switch self {
        case .audioTracks(let v):
          let i = v.checked
          switch i {
          case .empty:
            return []
          case .removeAll:
            return ["--no-audio"]
          default:
            return ["--audio-tracks", i.argument]
          }
        case .videoTracks(let v):
          let i = v.checked
          switch i {
          case .empty:
            return []
          case .removeAll:
            return ["--no-video"]
          default:
            return ["--video-tracks", i.argument]
          }
        case .subtitleTracks(let v):
          let i = v.checked
          switch i {
          case .empty:
            return []
          case .removeAll:
            return ["--no-subtitles"]
          default:
            return ["--subtitle-tracks", i.argument]
          }
        case .buttonTracks(let v):
          let i = v.checked
          switch i {
          case .empty:
            return []
          case .removeAll:
            return ["--no-buttons"]
          default:
            return ["--button-tracks", i.argument]
          }
        case .trackTags(let v):
          let i = v.checked
          switch i {
          case .empty:
            return []
          case .removeAll:
            return ["--no-track-tags"]
          default:
            return ["--track-tags", i.argument]
          }
        case .attachments(let v):
          let i = v.checked
          switch i {
          case .empty:
            return []
          case .removeAll:
            return ["--no-attachments"]
          default:
            return ["--attachments", i.argument]
          }
        case .noChapters:
          return ["--no-chapters"]
        case .noGlobalTags:
          return ["--no-global-tags"]
        case let .flag(tid: tid, flag, enabled):
          return ["--\(flag.rawValue)-flag", "\(tid):\(enabled ? "1" : "0")"]
        case .trackName(let tid, let name):
          return ["--track-name", "\(tid):\(name)"]
        case .language(let tid, language: let lang):
          return ["--language", "\(tid):\(lang)"]
        }
      }
    }
    public var file: String
    public var append: Bool
    public var lookForOtherParts: Bool
    public var options: [InputOption]

    public init(
      file: String, lookForOtherParts: Bool = false, append: Bool = false,
      options: [InputOption] = []
    ) {
      self.file = file
      self.lookForOtherParts = lookForOtherParts
      self.append = append
      self.options = options
    }

    var arguments: [String] {
      var r = options.flatMap { $0.arguments }
      if append {
        r.append("+")
      }
      if !lookForOtherParts {
        r.append("=")
      }
      r.append(file)
      return r
    }
  }
}
