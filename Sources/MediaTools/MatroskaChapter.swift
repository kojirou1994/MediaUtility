import XMLParsing
import Foundation
import MediaUtility

@available(*, deprecated, renamed: "MatroskaChapter")
public typealias MatroskaChapters = MatroskaChapter

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

    @available(*, deprecated, renamed: "uid")
    public var editionUID: UInt {
      set {
        uid = newValue
      }
      get {
        uid
      }
    }

    @available(*, deprecated, renamed: "isHidden")
    public var editionFlagHidden: Bool? {
      set {
        isHidden = newValue
      }
      get {
        isHidden
      }
    }

    @available(*, deprecated, renamed: "isManaged")
    public var editionManaged: Bool? {
      set {
        isManaged = newValue
      }
      get {
        isManaged
      }
    }

    @available(*, deprecated, renamed: "isDefault")
    public var editionFlagDefault: Bool? {
      set {
        isDefault = newValue
      }
      get {
        isDefault
      }
    }

    @available(*, deprecated, renamed: "chapters")
    public var chapterAtoms: [ChapterAtom] {
      set {
        chapters = newValue
      }
      get {
        chapters
      }
    }

    public var uid: UInt
    public var isHidden: Bool?
    public var isManaged: Bool?
    public var isOrdered: Bool?
    public var isDefault: Bool?
    public var chapters: [ChapterAtom]

    @available(*, deprecated, renamed: "init(uid:isHidden:isManaged:isOrdered:isDefault:chapters:)")
    public init(editionUID: UInt, editionFlagHidden: Bool?, editionManaged: Bool?,
                isOrdered: Bool? = nil,
                editionFlagDefault: Bool?, chapterAtoms: [ChapterAtom]) {
      self.uid = editionUID
      self.isHidden = editionFlagHidden
      self.isManaged = editionManaged
      self.isOrdered = isOrdered
      self.isDefault = editionFlagDefault
      self.chapters = chapterAtoms
    }

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

      @available(*, deprecated, renamed: "uid")
      public var chapterUID: UInt {
        set {
          uid = newValue
        }
        get {
          uid
        }
      }

      @available(*, deprecated, renamed: "startTime")
      public var chapterTimeStart: String {
        set {
          startTime = newValue
        }
        get {
          startTime
        }
      }

      @available(*, deprecated, renamed: "endTime")
      public var chapterTimeEnd: String? {
        set {
          endTime = newValue
        }
        get {
          endTime
        }
      }

      @available(*, deprecated, renamed: "displays")
      public var chapterDisplays: [ChapterDisplay]? {
        set {
          displays = newValue
        }
        get {
          displays
        }
      }

      public var uid: UInt
      public var startTime: String
      public var endTime: String?
      public var isHidden: Bool?
      public var isEnabled: Bool?
      public var displays: [ChapterDisplay]?

      @available(*, deprecated, renamed: "init(uid:startTime:endTime:isHidden:displays:)")
      public init(chapterUID: UInt,
                  chapterTimeStart: String, chapterTimeEnd: String?,
                  isHidden: Bool? = nil,
                  chapterDisplays: [ChapterDisplay]?) {
        self.uid = chapterUID
        self.startTime = chapterTimeStart
        self.endTime = chapterTimeEnd
        self.isHidden = isHidden
        self.displays = chapterDisplays
      }

      private enum CodingKeys: String, CodingKey {
        case uid = "ChapterUID"
        case startTime = "ChapterTimeStart"
        case endTime = "ChapterTimeEnd"
        case isHidden = "ChapterFlagHidden"
        case isEnabled = "ChapterFlagEnabled"
        case displays = "ChapterDisplay"
      }

      public struct ChapterDisplay: Codable, Equatable {
        public init(string: String, language: String, country: String? = nil) {
          self.string = string
          self.language = language
          self.country = country
        }

        @available(*, deprecated, renamed: "string")
        public var chapterString: String {
          set {
            string = newValue
          }
          get {
            string
          }
        }

        @available(*, deprecated, renamed: "language")
        public var chapterLanguage: String {
          set {
            language = newValue
          }
          get {
            language
          }
        }

        public var string: String
        public var language: String
        public var country: String?
        public var languageIETF: String?

        @available(*, deprecated, renamed: "init(string:language:)")
        public init(chapterString: String, chapterLanguage: String) {
          self.string = chapterString
          self.language = chapterLanguage
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
