import Foundation
import ExecutableDescription

public enum MkvExtractionMode {
  case tracks(TrackExtractionOption)
  case chapter(ChapterExtractionOption)
  public struct TrackExtractionOption {
    public init(outputs: [TrackOutput]) {
      self.outputs = outputs
    }

    public let outputs: [TrackOutput]
    public struct TrackOutput {
      public init(trackID: Int, filename: String) {
        self.trackID = trackID
        self.filename = filename
      }

      public let trackID: Int
      public let filename: String
    }
  }
  public struct ChapterExtractionOption {
    public init(simple: Bool, outputFilename: String) {
      self.simple = simple
      self.outputFilename = outputFilename
    }

    public let simple: Bool
    public let outputFilename: String
    //      let simpleLanguage: String?
  }
}
public struct MkvExtract: Executable {
  public init(filepath: String, extractions: [MkvExtractionMode]) {
    self.filepath = filepath
    self.extractions = extractions
  }

  public static let executableName = "mkvextract"

  public let filepath: String

  public let extractions: [MkvExtractionMode]

  public let parseFully: Bool = false

  public var arguments: [String] {
    var arg = [filepath]
    extractions.forEach { extraction in
      switch extraction {
      case .chapter(let opt):
        arg.append("chapters")
        if opt.simple {
          arg.append("-s")
        }
        arg.append(opt.outputFilename)
      default:
        assertionFailure("Not implemented")
        break
      }
    }
    return arg
  }

}
