public struct MkvMergeIdentification: Decodable {
  public var attachments: [Attachment]?
  public struct Attachment: Decodable {
    public var contentType: String?
    public var description: String?
    public var fileName: String
    public var id: UInt
    public var properties: Properties
    public struct Properties: Decodable {
      public var uid: UInt?
    }
    public var size: UInt
    public var type: String?
    private enum CodingKeys: String, CodingKey {
      case contentType = "content_type"
      case description
      case fileName = "file_name"
      case id
      case properties
      case size
      case type
    }
  }
  public var chapters: [Chapter]?
  public struct Chapter: Decodable {
    public var numEntries: Int
    private enum CodingKeys: String, CodingKey {
      case numEntries = "num_entries"
    }
  }
  public var container: Container?
  public struct Container: Decodable {
    public var properties: Properties?
    public struct Properties: Decodable {
      public var containerType: Int?
      public var dateLocal: String?
      public var dateUtc: String?
      public var duration: UInt?
      public var isProvidingTimestamps: Bool?
      public var muxingApplication: String?
      public var nextSegmentUid: String?
      public var otherFile: [String]?
      public var playlist: Bool?
      public var playlistChapters: UInt?
      public var playlistDuration: UInt?
      public var playlistFile: [String]?
      public var playlistSize: UInt?
      public var previousSegmentUid: String?
      public var programs: [Program]?
      public struct Program: Decodable {
        public var programNumber: UInt?
        public var serviceName: String?
        public var serviceProvider: String?
        private enum CodingKeys: String, CodingKey {
          case programNumber = "program_number"
          case serviceName = "service_name"
          case serviceProvider = "service_provider"
        }
      }
      public var segmentUid: String?
      public var title: String?
      public var writingApplication: String?
      private enum CodingKeys: String, CodingKey {
        case containerType = "container_type"
        case dateLocal = "date_local"
        case dateUtc = "date_utc"
        case duration
        case isProvidingTimestamps = "is_providing_timestamps"
        case muxingApplication = "muxing_application"
        case nextSegmentUid = "next_segment_uid"
        case otherFile = "other_file"
        case playlist
        case playlistChapters = "playlist_chapters"
        case playlistDuration = "playlist_duration"
        case playlistFile = "playlist_file"
        case playlistSize = "playlist_size"
        case previousSegmentUid = "previous_segment_uid"
        case programs
        case segmentUid = "segment_uid"
        case title
        case writingApplication = "writing_application"
      }
    }
    public var recognized: Bool
    public var supported: Bool
    public var type: String?
  }
  public var errors: [String]?
  public var fileName: String?
  public var globalTags: [GlobalTag]?
  public struct GlobalTag: Decodable {
    public var numEntries: Int
    private enum CodingKeys: String, CodingKey {
      case numEntries = "num_entries"
    }
  }
  public var identificationFormatVersion: Int?
  public var trackTags: [TrackTag]?
  public struct TrackTag: Decodable {
    public var numEntries: Int
    public var trackId: Int
    private enum CodingKeys: String, CodingKey {
      case numEntries = "num_entries"
      case trackId = "track_id"
    }
  }
  public var tracks: [Track]?
  public struct Track: Decodable {
    public var codec: String
    public var id: Int
    public var properties: Properties?
    public struct Properties: Decodable {
      public var aacIsSbr: AacIsSbr?
      public enum AacIsSbr: String, Decodable {
        case `true`
        case `false`
        case unknown
      }
      public var audioBitsPerSample: UInt?
      public var audioChannels: UInt?
      public var audioSamplingFrequency: UInt?
      public var codecDelay: Int?
      public var codecId: String?
      public var codecName: String?
      public var codecPrivateData: String?
      public var codecPrivateLength: UInt?
      public var contentEncodingAlgorithms: String?
      public var cropping: String?
      public var defaultDuration: UInt?
      public var defaultTrack: Bool?
      public var displayDimensions: String?
      public var displayUnit: UInt?
      public var enabledTrack: Bool?
      public var encoding: String?
      public var flagCommentary: Bool?
      public var flagHearingImpaired: Bool?
      public var flagOriginal: Bool?
      public var flagTextDescriptions: Bool?
      public var flagVisualImpaired: Bool?
      public var forcedTrack: Bool?
      public var language: String?
      public var languageIetf: String?
      public var minimumTimestamp: UInt?
      public var multiplexedTracks: [UInt]?
      public var number: UInt?
      public var packetizer: String?
      public var pixelDimensions: String?
      public var programNumber: UInt?
      public var stereoMode: UInt?
      public var streamId: UInt?
      public var subStreamId: UInt?
      public var tagArtist: String?
      public var tagBitsps: String?
      public var tagBps: String?
      public var tagFps: String?
      public var tagTitle: String?
      public var teletextPage: UInt?
      public var textSubtitles: Bool?
      public var trackName: String?
      public var uid: UInt?
      private enum CodingKeys: String, CodingKey {
        case aacIsSbr = "aac_is_sbr"
        case audioBitsPerSample = "audio_bits_per_sample"
        case audioChannels = "audio_channels"
        case audioSamplingFrequency = "audio_sampling_frequency"
        case codecDelay = "codec_delay"
        case codecId = "codec_id"
        case codecName = "codec_name"
        case codecPrivateData = "codec_private_data"
        case codecPrivateLength = "codec_private_length"
        case contentEncodingAlgorithms = "content_encoding_algorithms"
        case cropping
        case defaultDuration = "default_duration"
        case defaultTrack = "default_track"
        case displayDimensions = "display_dimensions"
        case displayUnit = "display_unit"
        case enabledTrack = "enabled_track"
        case encoding
        case flagCommentary = "flag_commentary"
        case flagHearingImpaired = "flag_hearing_impaired"
        case flagOriginal = "flag_original"
        case flagTextDescriptions = "flag_text_descriptions"
        case flagVisualImpaired = "flag_visual_impaired"
        case forcedTrack = "forced_track"
        case language
        case languageIetf = "language_ietf"
        case minimumTimestamp = "minimum_timestamp"
        case multiplexedTracks = "multiplexed_tracks"
        case number
        case packetizer
        case pixelDimensions = "pixel_dimensions"
        case programNumber = "program_number"
        case stereoMode = "stereo_mode"
        case streamId = "stream_id"
        case subStreamId = "sub_stream_id"
        case tagArtist = "tag_artist"
        case tagBitsps = "tag_bitsps"
        case tagBps = "tag_bps"
        case tagFps = "tag_fps"
        case tagTitle = "tag_title"
        case teletextPage = "teletext_page"
        case textSubtitles = "text_subtitles"
        case trackName = "track_name"
        case uid
      }
    }
    public var type: String
  }
  public var warnings: [String]?
  private enum CodingKeys: String, CodingKey {
    case attachments
    case chapters
    case container
    case errors
    case fileName = "file_name"
    case globalTags = "global_tags"
    case identificationFormatVersion = "identification_format_version"
    case trackTags = "track_tags"
    case tracks
    case warnings
  }
}
