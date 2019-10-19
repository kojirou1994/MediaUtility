import KwiftExtension

public struct Timestamp: LosslessStringConvertible {
    
    /// time in ns
    public var value: UInt64
    
    public init(ns time: UInt64) {
        value = time
    }
    
    public init(hour: UInt64, minute: UInt64, second: UInt64, milesecond: UInt64) {
        value = ((hour * 3600 + minute * 60 + second) * 1_000 + milesecond) * 1_000_000
    }
    
    ///
    ///
    /// - Parameter string: format: 00:00:00.000
    public init?(_ description: String) {
        // TODO: remove regularExpression
        guard description.count == 12,
            let _ = description.range(of: ###"\d\d:\d\d:\d\d.\d\d\d"###,
                                 options: String.CompareOptions.regularExpression,
                                 range: description.startIndex..<description.endIndex, locale: nil) else {
            return nil
        }
        let hour = UInt64(description[0...1])!
        let minute = UInt64(description[3...4])!
        let second = UInt64(description[6...7])!
        let milesecond = UInt64(description[9...11])!
        value = ((hour * 3600 + minute * 60 + second) * 1_000 + milesecond) * 1_000_000
    }
    
    public var description: String {
        var rest = value / 1_000_000 // ms
        let milesecond = rest % 1_000
        rest = rest / 1_000 // s
        let second = rest % 60
        rest = rest / 60 // minute
        let minute = rest % 60
        rest = rest / 60 // hour
        return String(format: "%02d:%02d:%02d.%03d", rest, minute, second, milesecond)
    }
    
}

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        lhs.value < rhs.value
    }
}

extension Timestamp: Hashable {}

extension Timestamp: Equatable {}

extension Timestamp {
    
    public static var hour: Timestamp {
        .init(ns: 3600_000_000_000)
    }
    
    public static var minute: Timestamp {
        .init(ns: 60_000_000_000)
    }
    
    public static var second: Timestamp {
        .init(ns: 1_000_000_000)
    }
    
    public static func * (lhs: Timestamp, rhs: UInt64) -> Timestamp {
        .init(ns: lhs.value * rhs)
    }
    
    public static func - (lhs: Timestamp, rhs: Timestamp) -> Timestamp {
        .init(ns: lhs.value - rhs.value)
    }
    
    public static func + (lhs: Timestamp, rhs: Timestamp) -> Timestamp {
        .init(ns: lhs.value + rhs.value)
    }
    
    public static func += (lhs: inout Timestamp, rhs: Timestamp) {
        lhs.value += rhs.value
    }
    
    public static func -= (lhs: inout Timestamp, rhs: Timestamp) {
        lhs.value -= rhs.value
    }

}
