import Foundation
import MediaUtility

public struct MkvmergeIdentification: Decodable {
    /// an array describing the attachments found if any
    public var attachments: [Attachment]
    public var chapters: [Chapter]
    /// information about the identified container
    public var container: Container
    public var errors: [String]
    public var fileName: String
    public var globalTags: [GlobalTag]
    public var identificationFormatVersion: Int
    public var trackTags: [TrackTag]
    public var tracks: [Track]
    public var warnings: [String]
    
    public struct Container: Decodable {
        /// additional properties for the container varying by container format
        public var properties: Properties?
        /// States whether or not mkvmerge knows about the format
        public var recognized: Bool
        /// States whether or not mkvmerge can read the format
        public var supported: Bool
        /// A human-readable description/name for the container format
        public var type: String?
        
        public struct Properties: Decodable {
            
            /// A unique number identifying the container type that's supposed to stay constant over all future releases of MKVToolNix
            public var containerType: Int?
            /// The muxing date in ISO 8601 format (in local time zone)
            public var dateLocal: String?
            /// The muxing date in ISO 8601 format (in UTC)
            public var dateUtc: String?
            /// The file's/segment's duration in nanoseconds
            public var duration: Int?
            /// States whether or not the container has timestamps for the packets (e.g. Matroska, MP4) or not (e.g. SRT, MP3)
            public var isProvidingTimestamps: Bool?
            /// A Unicode string containing the name and possibly version of the low-level library or application that created the file
            public var muxingApplication: String?
            /// A hexadecimal string of the next segment's UID (only for Matroska files)
            public var nextSegmentUid: String?
            /// An array of names of additional files processed as well
            public var otherFile: [String]?
            /// States whether or not the identified file is a playlist (e.g. MPLS) referring to several other files
            public var playlist: Bool?
            /// The number of chapters in a playlist if it is a one
            public var playlistChapters: Int?
            /// The total duration in nanoseconds of all files referenced by the playlist if it is a one
            public var playlistDuration: UInt64?
            /// An array of file names the playlist contains
            public var playlistFile: [String]?
            /// The total size in bytes of all files referenced by the playlist if it is a one
            public var playlistSize: Int?
            /// "A hexadecimal string of the previous segment's UID (only for Matroska files)
            public var previousSegmentUid: String?
            public var programs: [Program]?
            /// A hexadecimal string of the segment's UID (only for Matroska files)
            public var segmentUid: String?
            public var title: String?
            /// A Unicode string containing the name and possibly version of the high-level application that created the file
            public var writingApplication: String?
            
            /// A container describing multiple programs multiplexed into the source file, e.g. multiple programs in one DVB transport stream
            public struct Program: Decodable {
                /// A unique number identifying a set of tracks that belong together; used e.g. in DVB for multiplexing multiple stations within a single transport stream
                public var programNumber: Int?
                /// The name of a service provided by this program, e.g. a TV channel name such as 'arte HD'
                public var serviceName: String
                /// The name of the provider of the service provided by this program, e.g. a TV station name such as 'ARD'
                public var serviceProvider: String
                
                private enum CodingKeys: String, CodingKey {
                    case programNumber = "program_number"
                    case serviceName = "service_name"
                    case serviceProvider = "service_provider"
                }
            }
            
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
        
    }
    
    public struct GlobalTag: Decodable {
        public var numEntries: Int
        private enum CodingKeys: String, CodingKey {
            case numEntries = "num_entries"
        }
    }
    
    public struct TrackTag: Decodable {
        public var numEntries: Int
        public var trackId: Int
        private enum CodingKeys: String, CodingKey {
            case numEntries = "num_entries"
            case trackId = "track_id"
        }
    }
    
    public struct Track: Decodable {
        public var codec: String
        public var id: Int
        public var type: MediaTrackType
        public var properties: Properties
        
        public struct Properties: Decodable {
            
            public var aacIsSbr: AacIsSbr?
            public var audioBitsPerSample: Int?
            public var audioChannels: Int?
            public var audioSamplingFrequency: Int?
            public var codecDelay: Int?
            public var codecId: String?
            public var codecPrivateData: String?
            public var codecPrivateLength: Int?
            public var contentEncodingAlgorithms: String?
            public var defaultDuration: Int?
            public var defaultTrack: Bool?
            public var displayDimensions: String?
            public var displayUnit: Int?
            public var enabledTrack: Bool?
            public var encoding: String?
            public var forcedTrack: Bool?
            public var language: String?
            public var minimumTimestamp: Int?
            public var multiplexedTracks: [Int]?
            public var number: Int?
            public var packetizer: String?
            public var pixelDimensions: String?
            public var programNumber: Int?
            public var stereoMode: Int?
            public var streamId: Int?
            public var subStreamId: Int?
            public var tagArtist: String?
            public var tagBitsps: String?
            public var tagBps: String?
            public var tagFps: String?
            public var tagTitle: String?
            public var teletextPage: Int?
            public var textSubtitles: Bool?
            public var trackName: String?
            public var uid: UInt?
            
            public enum AacIsSbr: String, Decodable {
                case `true`,`false`,unknown
            }
            
            private enum CodingKeys: String, CodingKey {
                case aacIsSbr = "aac_is_sbr"
                case audioBitsPerSample = "audio_bits_per_sample"
                case audioChannels = "audio_channels"
                case audioSamplingFrequency = "audio_sampling_frequency"
                case codecDelay = "codec_delay"
                case codecId = "codec_id"
                case codecPrivateData = "codec_private_data"
                case codecPrivateLength = "codec_private_length"
                case contentEncodingAlgorithms = "content_encoding_algorithms"
                case defaultDuration = "default_duration"
                case defaultTrack = "default_track"
                case displayDimensions = "display_dimensions"
                case displayUnit = "display_unit"
                case enabledTrack = "enabled_track"
                case encoding
                case forcedTrack = "forced_track"
                case language
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
    }
    
    public struct Attachment: Decodable {
        public var contentType: String?
        public var description: String?
        public var fileName: String
        public var id: Int
        public var size: Int
        public var properties: Property
        public var type: String?
        
        public struct Property: Decodable {
            public var uid: UInt
        }
        
        private enum CodingKeys: String, CodingKey {
            case contentType = "content_type"
            case fileName = "file_name"
            case description
            case id
            case size
            case properties
            case type
        }
    }
    
    public struct Chapter: Decodable {
        public var numEntries: Int
        private enum CodingKeys: String, CodingKey {
            case numEntries = "num_entries"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case globalTags = "global_tags"
        case fileName = "file_name"
        case container
        case tracks
        case errors
        case trackTags = "track_tags"
        case attachments
        case identificationFormatVersion = "identification_format_version"
        case warnings
        case chapters
    }
    
}

internal let jsonDecoder = JSONDecoder()

extension MkvmergeIdentification {
    
    public init(url: URL) throws {
        try self.init(filePath: url.path)
    }
    
    public init(filePath: String) throws {
        self = try autoreleasepool {
            let mkvmerge = try AnyExecutable(executableName: "mkvmerge", arguments: ["-J", filePath]).runAndCatch(checkNonZeroExitCode: true)
            return try jsonDecoder.decode(Self.self, from: mkvmerge.stdout)
        }
    }
    
    public var primaryLanguages: [String] {
        var result = [String]()
        result.append(tracks.first {$0.type == .video}?.properties.language ?? "und")
        result.append(tracks.first {$0.type == .audio}?.properties.language ?? "und")
        return result
    }
    
}
