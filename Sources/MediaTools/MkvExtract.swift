import Foundation
import ExecutableDescription

/*
 Currently supported is the extraction of tracks, tags, attachments, chapters, CUE sheets, timestamps and cues.
 */

public enum MkvExtractionMode {
  case tracks(outputs: [TrackOutput])
  case tags(filename: String)
  case cuesheet(filename: String)
  case chapter(simple: Bool, language: String?, filename: String)
  case timestamps(outputs: [TrackOutput])
  case cues(outputs: [TrackOutput])
  case attachments(outputs: [TrackOutput])

  var cliMode: String {
    switch self {
    case .tracks: return "tracks"
    case .chapter: return "chapters"
    case .timestamps: return "timestamps_v2"
    case .cues: return "cues"
    case .tags: return "tags"
    case .cuesheet: return "cuesheet"
    case .attachments: return "attachments"
    }
  }

  public static func chapter(filename: String) -> Self {
    .chapter(simple: false, language: nil, filename: filename)
  }

  public struct TrackOutput {
    public init(trackID: Int, filename: String) {
      self.trackID = trackID
      self.filename = filename
    }

    /// in attachments mode, this means attachmentID
    public var trackID: Int
    public var filename: String
  }
}

public struct MkvExtract: Executable {
  public init(filepath: String, extractions: [MkvExtractionMode] = []) {
    self.filepath = filepath
    self.extractions = extractions
  }

  public static var executableName: String { "mkvextract" }

  public var filepath: String

  public var extractions: [MkvExtractionMode]

  public var arguments: [String] {
    var arg = [filepath]
    extractions.forEach { extraction in
      switch extraction {
      case let .chapter(simple: simple, language: language, filename: filename):
        arg.append(extraction.cliMode)
        if simple {
          arg.append("-s")
          language.map { arg.append("--simple-language") ; arg.append($0) }
        }
        arg.append(filename)
      case .tracks(let outputs), .timestamps(let outputs),
           .cues(let outputs), .attachments(let outputs):
        if outputs.isEmpty {
          return
        }
        arg.append(extraction.cliMode)
        outputs.forEach { output in
          arg.append("\(output.trackID):\(output.filename)")
        }
      case .tags(filename: let filename), .cuesheet(filename: let filename):
        arg.append(extraction.cliMode)
        arg.append(filename)
      }
    }
    return arg
  }

}
