import ExecutableDescription
import MediaUtility

public struct MkvPropEdit: Executable, IncrementalArguments {

  public static var executableName: String { "mkvpropedit" }

  public var parseMode: ParseMode? = nil

  public var filepath: String

  public var actions: [Action] = []

  public var trackStatisticsTagsAction: TrackStatisticsTagsAction?

  /// use "" to remove
  public var chapter: String?

  public var verbose: Bool = false

  public init(filepath: String) {
    self.filepath = filepath
  }

  public func writeArguments(to builder: inout ArgumentsBuilder) {

    builder.add(flag: "--parse-mode", value: parseMode)
    builder.add(flag: filepath)


    actions.forEach { action in
      builder.add(flag: "--edit", value: action.selector)
      action.modifications.forEach { mod in
        let flag: String
        let value: String
        switch mod {
        case let .add(name: name, value: v):
          flag = "--add"
          value = "\(name)=\(v)"
        case  let .set(name: name, value: v):
          flag = "--set"
          value = "\(name)=\(v)"
        case .delete(name: let name):
          flag = "--delete"
          value = name
        }
        builder.add(flag: flag, value: value)
      }
    }

    if let action = trackStatisticsTagsAction {
      builder.add(flag: "--\(action.rawValue)-track-statistics-tags")
    }
    builder.add(flag: "--chapters", value: chapter)

    builder.add(flag: "--verbose", when: verbose)
  }
}

extension MkvPropEdit {
  public enum ParseMode: String, CustomStringConvertible {
    case fast
    case full
    public var description: String { rawValue }
  }

  public enum TrackStatisticsTagsAction: String, CustomStringConvertible {
    case add
    case delete
    public var description: String { rawValue }
  }

  public struct Action {
    public init(selector: EditSelector, modifications: [Modification]) {
      self.selector = selector
      self.modifications = modifications
    }

    public let selector: EditSelector
    public var modifications: [Modification]

    public enum Modification {
      case add(name: String, value: String)
      case set(name: String, value: String)
      case delete(name: String)
    }
  }

  public enum EditSelector: CustomStringConvertible {
    case segmentInformation
    case track(TrackSelector)
    public enum TrackSelector {
      /// index starts at 1.
      case index(Int, type: MediaTrackType?)
      case uid(String)
      case trackNumber(Int)
    }

    public var description: String {
      switch self {
      case .segmentInformation: return "info"
      case .track(let selector):
        var option = "track:"
        switch selector {
        case .index(let index, let type):
          if let type = type {
            switch type {
            case .video:     option += "v"
            case .audio:     option += "a"
            case .subtitles: option += "s"
            }
          }
          option += index.description
        case .uid(let uid):
          option += "="
          option += uid
        case .trackNumber(let trackNumber):
          option += "@"
          option += trackNumber.description
        }
        return option
      }
    }
  }

}
