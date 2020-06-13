import XMLParsing
import Foundation

public struct MatroskaChapters: Codable, Equatable {

  public var entries: [EditionEntry]

  @inlinable
  public init(data: Data) throws {
    self = try XMLDecoder().decode(Self.self, from: data)
  }

  @inlinable
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
      public var chapterDisplays: [ChapterDisplay]

      public init(chapterUID: UInt, chapterTimeStart: String, chapterDisplays: [MatroskaChapters.EditionEntry.ChapterAtom.ChapterDisplay]) {
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
}