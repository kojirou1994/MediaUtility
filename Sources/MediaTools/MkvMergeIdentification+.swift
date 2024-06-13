import MediaUtility

extension MkvMergeIdentification.Track {
  public var trackType: MediaTrackType {
    .init(rawValue: type)!
  }
}
