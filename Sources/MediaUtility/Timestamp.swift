import KwiftExtension

public struct Timestamp: LosslessStringConvertible {
  /// time in ns
  public var value: UInt64

  @inlinable
  public init(ns time: UInt64) {
    value = time
  }

  @inlinable
  public init(hour: UInt64, minute: UInt64, second: UInt64, milesecond: UInt64, nanosecond: UInt64 = 0)
  {
    value =
      ((hour * 3_600 + minute * 60 + second) * 1_000 + milesecond) * 1_000_000 + nanosecond
  }

  ///
  ///
  /// - Parameter string: format: 00:00:00.000
  @inlinable
  public init?(_ description: String) {
    self.init(string: description, strictMode: true)
  }

  internal init?<S>(slow string: S) where S: StringProtocol {
    guard let sep1 = string.firstIndex(of: ":"),
      let hour = UInt64(string[..<sep1])
    else {
      return nil
    }

    let minuteStart = string.index(after: sep1)
    guard let sep2 = string[minuteStart...].firstIndex(of: ":"),
      let minute = UInt64(string[minuteStart..<sep2])
    else {
      return nil
    }

    let secondStart = string.index(after: sep2)
    guard let sep3 = string[secondStart...].firstIndex(of: "."),
      let second = UInt64(string[secondStart..<sep3])
    else {
      return nil
    }

    let milesecondStart = string.index(after: sep3)

    guard milesecondStart != string.endIndex,
      let milesecond = UInt64(string[milesecondStart...])
    else {
      return nil
    }

    self.init(
      hour: hour, minute: minute, second: second, milesecond: milesecond)
  }

  public init?<S>(string fast: S, strictMode: Bool = false) where S: StringProtocol {
    var hour: UInt64 = 0
    var minute: UInt64 = 0
    var second: UInt64 = 0
    var milesecond: UInt64 = 0
    var milesecondWidth: UInt = 0
    var position = 0
    for unit in fast.utf8 {
      switch unit {
      case UInt8(ascii: "0")...UInt8(ascii: "9"):
        let value: UInt64 = numericCast(unit - UInt8(ascii: "0"))
        switch position {
        case 0:
          hour = hour * 10 + value
        case 1:
          minute = minute * 10 + value
        case 2:
          second = second * 10 + value
        case 3:
          milesecondWidth += 1
          milesecond = milesecond * 10 + value
        default:
          return nil
        }
      case UInt8(ascii: ":"):
        if position < 2 {
          position += 1
        } else {
          return nil
        }
      case UInt8(ascii: "."):
        if position != 2 {
          return nil
        }
        position += 1
      default:
        return nil
      }
    }
    if strictMode, milesecondWidth != 3 {
      return nil
    }
    var nanosecond: UInt64
    switch milesecondWidth {
    case 0:
      return nil
    case 1: nanosecond = milesecond * 100 * 1000_000
    case 2: nanosecond = milesecond * 10 * 1000_000
    case 3: nanosecond = milesecond * 1000_000
    case 4...9:
      nanosecond = milesecond
      for _ in 0..<(9-milesecondWidth) {
        nanosecond *= 10
      }
    default:
      nanosecond = milesecond
      for _ in 1...milesecondWidth {
        nanosecond /= 10
      }
    }

    self.init(
      hour: hour, minute: minute, second: second, milesecond: 0, nanosecond: nanosecond)
  }

  public func toString(displayNanoSecond: Bool = false) -> String {
    var rest = value / 1_000_000  // ms
    let milesecond = rest % 1_000
    rest = rest / 1_000  // s
    let second = rest % 60
    rest = rest / 60  // minute
    let minute = rest % 60
    rest = rest / 60  // hour
    let nanosecond = value % 1_000_000
    return String(
      format: "%02d:%02d:%02d.%03d", rest, minute, second, milesecond)
    + (displayNanoSecond ? String(format: "%06d", nanosecond) : "")
  }

  public var description: String {
    toString()
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

  @inlinable
  public static var hour: Timestamp {
    .init(ns: 3_600_000_000_000)
  }

  @inlinable
  public static var minute: Timestamp {
    .init(ns: 60_000_000_000)
  }

  @inlinable
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
