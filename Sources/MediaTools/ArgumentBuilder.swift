struct ArgumentBuilder {
  init() {
    arguments = .init()
  }

  private(set) var arguments: [String]

  mutating func append<S>(argumentsFrom other: S) where S: Sequence, S.Element == String {
    arguments.append(contentsOf: other)
  }

  mutating func add(flag: String, value: String?) {
    if let v = value {
      arguments.append(flag)
      arguments.append(v)
    }
  }

  mutating func add<T: CustomArgumentConvertible & CustomStringConvertible>(flag: String, value: T?) {
    add(flag: flag, value: value?.argument)
  }

  mutating func add<T: CustomArgumentConvertible>(flag: String, value: T?) {
    add(flag: flag, value: value?.argument)
  }

  mutating func add<T: CustomStringConvertible>(flag: String, value: T?) {
    add(flag: flag, value: value?.description)
  }

  mutating func add(flag: String) {
    arguments.append(flag)
  }

  mutating func add(flag: String, when enabled: Bool) {
    if enabled {
      arguments.append(flag)
    }
  }
}

protocol CustomArgumentConvertible {
  var argument: String { get }
}
