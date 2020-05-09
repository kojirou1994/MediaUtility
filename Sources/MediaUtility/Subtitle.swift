public struct TimedText: Equatable, Hashable {

  public let startTime: Timestamp

  public let endTime: Timestamp

  public let text: String

  public init(start: Timestamp, end: Timestamp, text: String) {
    self.startTime = start
    self.endTime = end
    self.text = text
  }

}

public struct SRTSubtitle {

  public var subtitles: [TimedText]

  @inlinable
  public init(_ subtitles: [TimedText]) {
    self.subtitles = subtitles
  }

  @available(*, unavailable)
  public init(srt: String) {
    subtitles = []
  }

  public func export() -> String {
    subtitles.enumerated().map {
      """
      \($0.offset+1)
      \($0.element.startTime) --> \($0.element.endTime)
      \($0.element.text)

      """
    }.joined(separator: "\n")
  }

}
