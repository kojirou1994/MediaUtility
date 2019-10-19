public enum MediaTrackType: String, Codable, CustomStringConvertible {
    case video
    case audio
    case subtitles
    
    public var description: String {
        return rawValue
    }
}
