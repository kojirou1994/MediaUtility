public enum MediaTrackType: String, Codable, CustomStringConvertible, CaseIterable {
  case video
  case audio
  case subtitles

  public var description: String {
    rawValue
  }
}
