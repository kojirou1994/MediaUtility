struct ArgumentBuilder {
  init() {
    arguments = .init()
  }

  private(set) var arguments: [String]

  mutating func add<T: CustomStringConvertible>(flag: String, value: T?) {
    if let v = value {
      arguments.append(flag)
      arguments.append(v.description)
    }
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
