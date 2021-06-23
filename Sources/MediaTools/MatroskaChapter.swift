import XMLParsing
import Foundation
import MediaUtility

public struct MatroskaChapter: Codable, Equatable {

  public var entries: [EditionEntry]

  public init(data: Data) throws {
    self = try XMLDecoder().decode(Self.self, from: data)
  }

  public init(entries: [EditionEntry]) {
    self.entries = entries
  }

  private enum CodingKeys: String, CodingKey {
    case entries = "EditionEntry"
  }

  public struct EditionEntry: Codable, Equatable {

    public init(uid: UInt, isHidden: Bool? = nil, isManaged: Bool? = nil, isOrdered: Bool? = nil, isDefault: Bool? = nil, chapters: [ChapterAtom]) {
      self.uid = uid
      self.isHidden = isHidden
      self.isManaged = isManaged
      self.isOrdered = isOrdered
      self.isDefault = isDefault
      self.chapters = chapters
    }

    public var uid: UInt
    public var isHidden: Bool?
    public var isManaged: Bool?
    public var isOrdered: Bool?
    public var isDefault: Bool?
    public var chapters: [ChapterAtom]

    private enum CodingKeys: String, CodingKey {
      case uid = "EditionUID"
      case isHidden = "EditionFlagHidden"
      case isManaged = "EditionManaged"
      case isOrdered = "EditionFlagOrdered"
      case isDefault = "EditionFlagDefault"
      case chapters = "ChapterAtom"
    }

    public struct ChapterAtom: Codable, Equatable {
      public init(uid: UInt, startTime: String, endTime: String? = nil, isHidden: Bool? = nil, displays: [ChapterDisplay]? = nil) {
        self.uid = uid
        self.startTime = startTime
        self.endTime = endTime
        self.isHidden = isHidden
        self.displays = displays
      }

      public var uid: UInt
      public var startTime: String
      public var endTime: String?
      public var isHidden: Bool?
      public var isEnabled: Bool?
      public var displays: [ChapterDisplay]?

      private enum CodingKeys: String, CodingKey {
        case uid = "ChapterUID"
        case startTime = "ChapterTimeStart"
        case endTime = "ChapterTimeEnd"
        case isHidden = "ChapterFlagHidden"
        case isEnabled = "ChapterFlagEnabled"
        case displays = "ChapterDisplay"
      }

      public struct ChapterDisplay: Codable, Equatable {
        public init(string: String, language: String?, country: String? = nil) {
          self.string = string
          self.language = language
          self.country = country
        }

        public var string: String
        public var language: String?
        public var country: String?
        public var languageIETF: String?

        public init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          string = try container.decodeIfPresent(String.self, forKey: .string) ?? ""
          language = try container.decodeIfPresent(String.self, forKey: .language)
          country = try container.decodeIfPresent(String.self, forKey: .country)
          languageIETF = try container.decodeIfPresent(String.self, forKey: .languageIETF)
        }

        private enum CodingKeys: String, CodingKey {
          case string = "ChapterString"
          case language = "ChapterLanguage"
          case country = "ChapterCountry"
          case languageIETF = "ChapLanguageIETF"
        }
      }
    }
  }

  private static let header = """
  <?xml version="1.0"?>
  <!-- <!DOCTYPE Chapters SYSTEM "matroskachapters.dtd"> -->\n
  """

  private func encodedXML() throws -> Data {
    try XMLEncoder().encode(self, withRootKey: "Chapters")
  }

  public func exportXML() throws -> Data {
    var data = Data()
    data.append(contentsOf: Self.header.utf8)
    data.append(try encodedXML())
    return data
  }

  public func encodedXMLBytes() throws -> [UInt8] {
    var bytes = [UInt8]()
    bytes.append(contentsOf: Self.header.utf8)
    bytes.append(contentsOf: try encodedXML())
    return bytes
  }
}

extension MatroskaChapter.EditionEntry.ChapterAtom {
  @_transparent
  public var timestamp: Timestamp? {
    Timestamp(string: startTime, strictMode: false)
  }
}

extension MatroskaChapter.EditionEntry {
  @_transparent
  public var isEmpty: Bool {
    switch chapters.count {
    case 0:
      return true
    case 1:
      return chapters[0].timestamp?.value == 0
    default:
      return false
    }
  }
}
