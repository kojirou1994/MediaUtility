import XMLCoder
import Foundation
import MediaUtility

extension KeyedDecodingContainer {
  fileprivate func decode(_ type: MatroskaChapterBool.Type, forKey key: Self.Key) throws -> MatroskaChapterBool {
    try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
  }
}

extension KeyedEncodingContainer {
  fileprivate mutating func encode(_ value: MatroskaChapterBool, forKey key: KeyedEncodingContainer<K>.Key) throws {
    try encodeIfPresent(value.rawValue, forKey: key)
  }
}

@propertyWrapper
public struct MatroskaChapterBool: Codable, Equatable, CustomStringConvertible {
  public var wrappedValue: Bool?

  public init(wrappedValue: Bool?) {
    self.wrappedValue = wrappedValue
  }

  private init(_ rawValue: UInt?) {
    if let v = rawValue {
      wrappedValue = v > 0
    } else {
      wrappedValue = nil
    }
  }

  public var description: String { String(describing: wrappedValue) }

  fileprivate var rawValue: UInt? {
    if let v = wrappedValue {
      return v ? 1 : 0
    } else {
      return nil
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    if let rawValue = rawValue {
      try container.encode(rawValue)
    } else {
      try container.encodeNil()
    }
  }

  public init(from decoder: Decoder) throws {
    self.init(try decoder.singleValueContainer().decode(UInt.self))
  }
}

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

    public init(uid: UInt = 0, isHidden: Bool? = nil, isManaged: Bool? = nil, isOrdered: Bool? = nil, isDefault: Bool? = nil, chapters: [ChapterAtom]) {
      self.uid = uid
      self.isHidden = isHidden
      self.isManaged = isManaged
      self.isOrdered = isOrdered
      self.isDefault = isDefault
      self.chapters = chapters
    }

    public var uid: UInt

    @MatroskaChapterBool
    public var isHidden: Bool?

    @MatroskaChapterBool
    public var isManaged: Bool?

    @MatroskaChapterBool
    public var isOrdered: Bool?

    @MatroskaChapterBool
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
      public init(uid: UInt = 0, startTime: String, endTime: String? = nil, isHidden: Bool? = nil, displays: [ChapterDisplay]? = nil) {
        self.uid = uid
        self.startTime = startTime
        self.endTime = endTime
        self.isHidden = isHidden
        self.displays = displays
      }

      public init(startTime: Timestamp, endTime: Timestamp? = nil) {
        self.init(startTime: startTime.toString(displayNanoSecond: true), endTime: endTime?.toString(displayNanoSecond: true))
      }

      public var uid: UInt

      public var startTime: String

      public var endTime: String?

      @MatroskaChapterBool
      public var isHidden: Bool?

      @MatroskaChapterBool
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
    let encoder = XMLEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.prettyPrintIndentation = .spaces(2)
    return try encoder.encode(self, withRootKey: "Chapters")
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
  /// safe start timestamp
  public var timestamp: Timestamp? {
    Timestamp(string: startTime, strictMode: false)
  }

  /// start timestamp, getter is not safe
  public var startTimestamp: Timestamp {
    get {
      Timestamp(string: startTime, strictMode: false)!
    }
    set {
      startTime = newValue.toString(displayNanoSecond: true)
    }
  }

  /// end timestamp, getter is not safe
  public var endTimestamp: Timestamp? {
    get {
      endTime.map { Timestamp(string: $0, strictMode: false)! }
    }
    set {
      endTime = newValue?.toString(displayNanoSecond: true)
    }
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

extension MatroskaChapter {
  public mutating func fillUIDs() {
    var uids = Set<UInt>()
    func nextUID() -> UInt {
      while true {
        let result = uids.insert(.random(in: UInt.min...UInt.max))
        if result.inserted {
          return result.memberAfterInsert
        }
      }
      fatalError("Cannot generate enough uids!")
    }
    entries.mutateEach {
      $0.uid = nextUID()
      $0.chapters.mutateEach {
        $0.uid = nextUID()
      }
    }
  }
}
