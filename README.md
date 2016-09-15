# CountedSet

 [![codecov.io](https://codecov.io/github/daehn/CountedSet/coverage.svg?branch=develop)](https://codecov.io/github/daehn/CountedSet?branch=develop) ![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Minimal implementation of a counted Set in Swift.

Start by creating a `CountedSet` instance using a `Hashable` element type and by adding and removing objects:

```swift
let words = CountedSet<String>()
words.insert("Hello")
words.insert("World")
words.insert("Hello")
words.remove("World")
```

You can ask the `CountedSet` for the count of an element, which is also possible using subscripting:

```swift
let helloCount = words.count(for: "Hello") // 2
let worldCount = words.count(for: "World") // nil
let anotherHelloCount = words["Hello"] // 2
```

Access the most occurring element and its count, which will be returned as an optional tuple containing the element and its count:

```swift
if let (element, count) = words.mostFrequent() {
    // Do something with element and count
}
```
