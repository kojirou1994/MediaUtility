import Foundation

public struct Mkvmerge: Executable {
    public static let executableName: String = "mkvmerge"
    
    public let global: GlobalOption
    
    public struct GlobalOption {

        // 2.1. Global options
        public var verbose: Bool
        public var quiet: Bool
        public var webm: Bool
        public var title: String
        public var defaultLanguage: String?

        // 2.2. Segment info handling (global options)
        // invalie now

        // 2.3. Chapter and tag handling (global options)
        public var chapterLanguage: String?
        public var chapterFile: String?

        // 2.4. General output control (advanced global options)
        public var trackOrder: [TrackOrder]?

        // 2.5. File splitting, linking, appending and concatenation (more global options)
        public var split: Split?
        public enum Split {
            /// size in bytes
            case size(Int)
//            case duration(seconds: Int)
            case chapters(ChapterSplit)
            public enum ChapterSplit {
                case all
                case numbers([Int])
            }
        }
        public struct TrackOrder {
            public let fid: Int
            public let tid: Int
            var argument: String { "\(fid):\(tid)" }
            public init(fid: Int, tid: Int) {
                self.fid = fid
                self.tid = tid
            }
        }

        public init(verbose: Bool = false, quiet: Bool, webm: Bool = false,
                    title: String = "", defaultLanguage: String? = nil,
                    split: Split? = nil, trackOrder: [TrackOrder]? = nil,
                    chapterLanguage: String? = nil, chapterFile: String? = nil) {
            self.verbose = verbose
            self.quiet = quiet
            self.webm = webm
            self.title = title
            self.defaultLanguage = defaultLanguage
            self.split = split
            self.trackOrder = trackOrder
            self.chapterLanguage = chapterLanguage
            self.chapterFile = chapterFile
        }
        
        var arguments: [String] {
            var r = [String]()
            if verbose {
                r.append("--verbose")
            }
            if quiet {
                r.append("--quiet")
            }
            if webm {
                r.append("--webm")
            }
            r.append(contentsOf: ["--title", title])
            if let l = defaultLanguage {
                r.append(contentsOf: ["--default-language", l])
            }
            if let to = trackOrder, !to.isEmpty {
                r.append("--track-order")
                r.append(to.map{$0.argument}.joined(separator: ","))
            }
            if let c = chapterLanguage, !c.isEmpty {
                r.append("--chapter-language")
                r.append(c)
            }
            if let c = chapterFile, !c.isEmpty {
                r.append("--chapters")
                r.append(c)
            }
            if let s = split {
                r.append("--split")
                switch s {
                case .size(let bytes):
                    r.append(String(describing: bytes))
                case .chapters(.all):
                    r.append("chapters:all")
                case .chapters(.numbers(let numbers)):
                    r.append("chapters:\(numbers.map{String(describing: $0)}.joined(separator: ","))")
                }
            }
            return r
        }
    }
    
    public let output: String
    
    public let inputs: [Input]
    
    public struct Input {
        public enum InputOption {
            public enum TrackSelect {
                case empty
                case removeAll
                case enabledTIDs([Int])
                case enabledLANGs(Set<String>)
                case disabledTIDs([Int])
                case disabledLANGS(Set<String>)
                
                var checked: TrackSelect {
                    switch self {
                    case .enabledTIDs(let tids), .disabledTIDs(let tids):
                        if tids.isEmpty {
                            return .empty
                        } else {
                            return self
                        }
                    case .enabledLANGs(let langs), .disabledLANGS(let langs):
                        if langs.isEmpty {
                            return .empty
                        } else {
                            return self
                        }
                    default: return self
                    }
                }
                
                var argument: String {
                    switch self {
                    case .enabledTIDs(let tids):
                        return tids.map {String(describing: $0)}.joined(separator: ",")
                    case .disabledTIDs(let tids):
                        return "!" + tids.map {String(describing: $0)}.joined(separator: ",")
                    case .enabledLANGs(let langs):
                        return langs.joined(separator: ",")
                    case .disabledLANGS(let langs):
                        return "!" + langs.joined(separator: ",")
                    default:
                        fatalError()
                    }
                }
                
            }
            case audioTracks(TrackSelect)
            case videoTracks(TrackSelect)
            case subtitleTracks(TrackSelect)
            case buttonTracks(TrackSelect)
            case trackTags(TrackSelect)
            case attachments(TrackSelect)
            case noChapters
            case noGlobalTags
            case trackName(tid: Int, name: String)
            case language(tid: Int, language: String)
            
            var arguments: [String] {
                switch self {
                case .audioTracks(let v):
                    let i = v.checked
                    switch i {
                    case .empty:
                        return []
                    case .removeAll:
                        return ["--no-audio"]
                    default:
                        return ["--audio-tracks", i.argument]
                    }
                case .videoTracks(let v):
                    let i = v.checked
                    switch i {
                    case .empty:
                        return []
                    case .removeAll:
                        return ["--no-video"]
                    default:
                        return ["--video-tracks", i.argument]
                    }
                case .subtitleTracks(let v):
                    let i = v.checked
                    switch i {
                    case .empty:
                        return []
                    case .removeAll:
                        return ["--no-subtitles"]
                    default:
                        return ["--subtitle-tracks", i.argument]
                    }
                case .buttonTracks(let v):
                    let i = v.checked
                    switch i {
                    case .empty:
                        return []
                    case .removeAll:
                        return ["--no-buttons"]
                    default:
                        return ["--button-tracks", i.argument]
                    }
                case .trackTags(let v):
                    let i = v.checked
                    switch i {
                    case .empty:
                        return []
                    case .removeAll:
                        return ["--no-track-tags"]
                    default:
                        return ["--track-tags", i.argument]
                    }
                case .attachments(let v):
                    let i = v.checked
                    switch i {
                    case .empty:
                        return []
                    case .removeAll:
                        return ["--no-attachments"]
                    default:
                        return ["--attachments", i.argument]
                    }
                case .noChapters:
                    return ["--no-chapters"]
                case .noGlobalTags:
                    return ["--no-global-tags"]
                case .trackName(tid: let tid, name: let name):
                    return ["--track-name", "\(tid):\(name)"]
                case .language(tid: let tid, language: let lang):
                    return ["--language", "\(tid):\(lang)"]
                }
            }
        }
        public let file: String
        public let append: Bool
        public let lookForOtherParts: Bool
        public var options: [InputOption]
        
        public init(file: String, lookForOtherParts: Bool = false, append: Bool = false, options: [InputOption] = []) {
            self.file = file
            self.lookForOtherParts = lookForOtherParts
            self.append = append
            self.options = options
        }
        
        var arguments: [String] {
            var r = options.flatMap{$0.arguments}
            if append {
                r.append("+")
            }
            if !lookForOtherParts {
                r.append("=")
            }
            r.append(file)
            return r
        }
    }
    
    public var arguments: [String] {
        let args = global.arguments + ["--output", output] + inputs.flatMap {$0.arguments}
        if args.count >= 4096 {
            let optionsFile = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).json")
            try! JSONSerialization.data(withJSONObject: args, options: [.prettyPrinted]).write(to: optionsFile)
            return ["@\(optionsFile.path)"]
        } else {
            return args
        }
    }
    
    public init(global: GlobalOption, output: String, inputs: [Mkvmerge.Input]) {
        self.global = global
        self.output = output
        self.inputs = inputs
    }
}
