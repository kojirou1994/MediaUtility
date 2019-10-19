@_exported import Executable

public enum MediaTools: String {
    case ffmpeg
    case mkvextract
    case mp4Box = "MP4Box"
    case LsmashRemuxer = "remuxer"
    
    public func executable(_ arguments: [String]) -> AnyExecutable {
        return .init(executableName: rawValue, arguments: arguments)
    }
}
