//
// The MIT License (MIT)
// Copyright 2016 Silvan Dähn
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


public struct CountedSet<Element : Hashable> : ExpressibleByArrayLiteral {

    public typealias ElementWithCount = (element: Element, count: Int)
    public typealias Index = SetIndex<Element>

    fileprivate var backing = Set<Element>()
    fileprivate var countByElement = [Element: Int]()

    public mutating func insert(_ member: Element) {
        backing.insert(member)
        let count = countByElement[member] ?? 0
        countByElement[member] = count + 1
    }

    @discardableResult public mutating func remove(_ member: Element) -> Element? {
        guard var count = countByElement[member], count > 0 else { return nil }
        count -= 1
        countByElement[member] = Swift.max(count, 0)
        if count <= 0 { backing.remove(member) }
        return member
    }

    public func count(for member: Element) -> Int {
        return countByElement[member] ?? 0
    }

    public init(arrayLiteral elements: Element...) {
        elements.forEach { insert($0) }
    }

    public subscript(member: Element) -> Int {
        return count(for: member)
    }
    
    @discardableResult public mutating func setCount(_ count: Int, for element: Element) -> Bool {
        precondition(count >= 0, "Count has to be positive")
        guard contains(element) else { return false }
        countByElement[element] = count
        if count <= 0 { backing.remove(element) }
        return true
    }

    public func mostFrequent() -> ElementWithCount? {
        guard !backing.isEmpty else { return nil }
        return reduce((backing[backing.startIndex], 0)) { max, current in
            let currentCount = count(for: current)
            guard currentCount > max.1 else { return max }
            return (current, currentCount)
        }
    }

}

// MARK: - Collection

extension CountedSet: Collection {

    public var startIndex: SetIndex<Element> {
        return backing.startIndex
    }

    public var endIndex: SetIndex<Element> {
        return backing.endIndex
    }

    public func index(after i: SetIndex<Element>) -> SetIndex<Element> {
        return backing.index(after: i)
    }

    public subscript(position: SetIndex<Element>) -> Element {
        return backing[position]
    }

    public func makeIterator() -> SetIterator<Element> {
        return backing.makeIterator()
    }

}

// MARK: - Hashable

extension CountedSet: Hashable {

    public var hashValue: Int {
        return backing.hashValue ^ Int(countByElement.values.reduce(0, ^))
    }

}

// MARK: - Equatable Operator

public func ==<Element>(lhs: CountedSet<Element>, rhs: CountedSet<Element>) -> Bool {
    return lhs.backing == rhs.backing && lhs.countByElement == rhs.countByElement
}

// MARK: - CustomStringConvertible

extension CountedSet: CustomStringConvertible {

    public var description: String {
        return backing.reduce("<CountedSet>:\n") { sum, element in
            sum + "\t- \(element) : \(count(for: element))x\n"
        }
    }
    
}
