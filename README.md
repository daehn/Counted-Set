# CountedSet

 [![codecov.io](https://codecov.io/github/daehn/CountedSet/coverage.svg?branch=develop)](https://codecov.io/github/daehn/CountedSet?branch=develop) ![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Minimal implementation of a counted Set in Swift.

Start by creating a `CountedSet` instance using a `Hashable` element type and by adding and removing objects:

```swift
let set = CountedSet<String>()
set.insert("Hello")
set.insert("World")
set.insert("Hello")
set.remove("World")
```

You can ask the `CountedSet` for the count of an element, which is also possible using subscripting:

```swift
let helloCount = set.count(for: "Hello") // 2
let worldCount = set.count(for: "World") // nil
let anotherHelloCount = set["Hello"] // 2
```

Access the most occurring element and its count, which will be returned as an optional tuple containing the element and its count:

```swift
if let (element, count) = set.mostFrequent() {
    // Do something with element and count
}
```
