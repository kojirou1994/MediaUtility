import XMLParsing
import Foundation
import MediaUtility

public struct MatroskaChapters: Codable, Equatable {

  public var entries: [EditionEntry]

  public init(data: Data) throws {
    self = try XMLDecoder().decode(Self.self, from: data)
  }

  public init(entries: [MatroskaChapters.EditionEntry]) {
    self.entries = entries
  }

  private enum CodingKeys: String, CodingKey {
    case entries = "EditionEntry"
  }

  public struct EditionEntry: Codable, Equatable {

    public var editionUID: UInt
    public var editionFlagHidden: Bool?
    public var editionManaged: Bool?
    public var editionFlagDefault: Bool?
    public var chapterAtoms: [ChapterAtom]

    public init(editionUID: UInt, editionFlagHidden: Bool?, editionManaged: Bool?, editionFlagDefault: Bool?, chapterAtoms: [MatroskaChapters.EditionEntry.ChapterAtom]) {
      self.editionUID = editionUID
      self.editionFlagHidden = editionFlagHidden
      self.editionManaged = editionManaged
      self.editionFlagDefault = editionFlagDefault
      self.chapterAtoms = chapterAtoms
    }

    private enum CodingKeys: String, CodingKey {
      case editionUID = "EditionUID"
      case editionFlagHidden = "EditionFlagHidden"
      case editionManaged = "EditionManaged"
      case editionFlagDefault = "EditionFlagDefault"
      case chapterAtoms = "ChapterAtom"
    }

    public struct ChapterAtom: Codable, Equatable {

      public var chapterUID: UInt
      public var chapterTimeStart: String
      public var chapterDisplays: [ChapterDisplay]?

      public init(chapterUID: UInt, chapterTimeStart: String, chapterDisplays: [MatroskaChapters.EditionEntry.ChapterAtom.ChapterDisplay]?) {
        self.chapterUID = chapterUID
        self.chapterTimeStart = chapterTimeStart
        self.chapterDisplays = chapterDisplays
      }

      private enum CodingKeys: String, CodingKey {
        case chapterUID = "ChapterUID"
        case chapterTimeStart = "ChapterTimeStart"
        case chapterDisplays = "ChapterDisplay"
      }

      public struct ChapterDisplay: Codable, Equatable {
        public var chapterString: String
        public var chapterLanguage: String

        public init(chapterString: String, chapterLanguage: String) {
          self.chapterString = chapterString
          self.chapterLanguage = chapterLanguage
        }

        private enum CodingKeys: String, CodingKey {
          case chapterString = "ChapterString"
          case chapterLanguage = "ChapterLanguage"
        }
      }
    }
  }

  static let header = Data("""
  <?xml version="1.0"?>
  <!-- <!DOCTYPE Chapters SYSTEM "matroskachapters.dtd"> -->\n
  """.utf8)

  public func exportXML() throws -> Data {
    try Self.header + XMLEncoder().encode(self, withRootKey: "Chapters")
  }
}

extension MatroskaChapters.EditionEntry.ChapterAtom {
  @_transparent
  public var timestamp: Timestamp? {
    Timestamp(string: chapterTimeStart, strictMode: false)
  }
}

extension MatroskaChapters.EditionEntry {
  @_transparent
  public var isEmpty: Bool {
    switch chapterAtoms.count {
    case 0:
      return true
    case 1:
      return chapterAtoms[0].timestamp?.value == 0
    default:
      return false
    }
  }
}
